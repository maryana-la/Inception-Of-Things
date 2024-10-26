#!/bin/bash
set -e

if ! command -v k3d &> /dev/null || ! command -v kubectl &> /dev/null; then
    echo "Error: k3d and kubectl are required but not installed."
    exit 1
fi
k3d cluster create my-cluster

k3d kubeconfig get my-cluster > ~/.kube/config


until kubectl cluster-info; do
    echo "Waiting for the cluster to be ready..."
    sleep 2
done

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Checking Argo CD installation..."
kubectl wait --for=condition=available --timeout=600s deployment -n argocd -l app.kubernetes.io/name=argocd-server

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl port-forward svc/argocd-server -n argocd 8082:80 &

until nc -z localhost 8082; do
    echo "Waiting for port-forwarding to establish connection on localhost:8082..."
    sleep 2
done

ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
echo $ARGOCD_PASSWORD > argocd_password.txt
argocd login localhost:8082 --insecure --username admin --password $ARGOCD_PASSWORD
argocd account update-password --account admin --current-password $ARGOCD_PASSWORD --new-password 7heavens



kubectl create namespace dev

echo "Namespaces 'argocd' and 'dev' have been successfully created and configured."

kubectl config set-context --current --namespace=argocd

# argocd cluster add k3d-my-cluster

argocd app create my-app \
  --repo https://github.com/OlgaKush512/okushnir_IoT.git \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated

argocd app sync my-app
