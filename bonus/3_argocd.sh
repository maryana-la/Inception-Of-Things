#!/bin/bash

# Создание namespace для Argo CD
kubectl create namespace argocd

# Установка Argo CD с использованием Helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd -n argocd

# Проверка установки Argo CD
kubectl get pods -n argocd
