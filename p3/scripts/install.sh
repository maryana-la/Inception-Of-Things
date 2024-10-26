#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

if ! command -v docker &> /dev/null
then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker installed. Please restart the terminal."
else
    echo "Docker is already installed."
fi

if ! command -v k3d &> /dev/null
then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "K3D is already installed."
fi

if ! command -v kubectl &> /dev/null
then
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/
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
