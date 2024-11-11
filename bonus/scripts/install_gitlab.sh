#!/bin/bash

# install helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo bash get_helm.sh

# create namespace gitlab
sudo kubectl create namespace gitlab

# install gitlab with helm
sudo helm repo add gitlab https://charts.gitlab.io
sudo helm repo update
# sudo helm pull gitlab/gitlab --untar

sudo helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  -f ../confs/gitlab-values.yaml \
  --set global.hosts.domain=gitlab.iot.com \
  --set global.hosts.hostAliases[0].ip="127.0.0.1" \
  --set global.hosts.hostAliases[0].hostnames[0]="gitlab.iot.com" \
  --set global.hosts.hostAliases[0].hostnames[1]="localhost" \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.hosts.https=false \
  --timeout 600s \
  --debug

# add gitlab domain to hosts
sudo echo "127.0.0.1 gitlab.iot.com" | sudo tee -a "/etc/hosts" > /dev/null

# waiting for gitlab to be ready
sudo kubectl wait --for=condition=available --timeout=1800s deployment/gitlab-webservice-default -n gitlab

while true; do
    sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 --address="0.0.0.0" >/dev/null 2>&1 &
    sleep 20
done &


# get gitlab password
GITLAB_PASSWORD=$(sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

# save gitlab credentials
 sudo echo "machine gitlab.iot.com
 login root
 password ${GITLAB_PASSWORD}" > ~/.netrc
 sudo cp ~/.netrc /root/
 sudo chmod 600 /root/.netrc
 sudo chmod 600 ~/.netrc

# print gitlab password
echo "Password:"
echo "${GITLAB_PASSWORD}"
