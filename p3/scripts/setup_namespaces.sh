#!/bin/bash


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

kubectl create namespace dev

echo "Namespaces 'argocd' and 'dev' have been successfully created and configured."
