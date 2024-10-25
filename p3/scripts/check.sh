#!/bin/bash

echo "Checking K3D cluster..."
k3d cluster list

echo "Checking Kubeconfig..."
kubectl config current-context

echo "Checking Kubernetes cluster info..."
kubectl cluster-info

echo "Checking Argo CD pods..."
kubectl get pods -n argocd

echo "Checking Argo CD services..."
kubectl get svc -n argocd

echo "Checking namespaces..."
kubectl get namespaces
