#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

if ! command -v docker &> /dev/null
then
    sudo curl -fsSL https://get.docker.com -o get-docker.sh
    sudo chmod +x get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installed."
else
    echo "Docker is already installed."
fi

if ! command -v k3d &> /dev/null
then
    sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "K3D is already installed."
fi

if ! command -v kubectl &> /dev/null
then
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
    echo "kubectl is already installed."
fi


if ! command -v argocd &> /dev/null
then
    sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo chmod +x /usr/local/bin/argocd
else
    echo "Argo CD CLI is already installed."
fi

echo "Installation completed."
