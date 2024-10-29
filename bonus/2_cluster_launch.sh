#!/bin/bash

# Создание кластера K3d с именем mycluster
sudo k3d cluster create mycluster --api-port 6550 -p "8080:80@loadbalancer" -p "8888:8888@loadbalancer"

# Проверка состояния кластера
sudo kubectl get nodes

# Создание namespace для GitLab
sudo kubectl create namespace gitlab

# Установка GitLab с помощью Helm
sudo helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=local \
  --set global.hosts.externalIP=127.0.0.1 \
  --set certmanager-issuer.email=example@example.com

# Проверка установки GitLab
sudo kubectl get pods -n gitlab

