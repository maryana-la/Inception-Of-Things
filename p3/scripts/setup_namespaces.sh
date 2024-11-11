#!/bin/bash
set -e

if ! command -v k3d &> /dev/null || ! command -v kubectl &> /dev/null; then
    echo "Error: k3d and kubectl are required but not installed."
    exit 1
fi
sudo k3d cluster create IoT

mkdir ~/.kube
sudo k3d kubeconfig get IoT > ~/.kube/config


until sudo kubectl cluster-info; do
    echo "Waiting for the cluster to be ready..."
    sleep 2
done

sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Checking Argo CD installation..."
sudo kubectl wait --for=condition=available --timeout=600s deployment -n argocd -l app.kubernetes.io/name=argocd-server

sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
sudo kubectl port-forward svc/argocd-server -n argocd 8082:80 >/dev/null 2>&1 &

until nc -z localhost 8082; do
    echo "Waiting for port-forwarding to establish connection on localhost:8082..."
    sleep 2
done

ARGOCD_PASSWORD=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
sudo argocd login localhost:8082 --insecure --username admin --password $ARGOCD_PASSWORD
sudo argocd account update-password --account admin --current-password $ARGOCD_PASSWORD --new-password 7heavens


sudo kubectl create namespace dev

echo "Namespaces 'argocd' and 'dev' have been successfully created and configured."

sudo kubectl config set-context --current --namespace=argocd

sudo kubectl apply -f ../confs/argocd-app.yaml

while true; do
    sudo kubectl port-forward svc/svc-wil-playground -n dev 8888:8888 >/dev/null 2>&1 &
    sleep 20
done &

sudo argocd app sync my-app
