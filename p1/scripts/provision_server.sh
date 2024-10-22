#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y curl
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip 192.168.56.110" K3S_KUBECONFIG_MODE="644" sh -
cp /var/lib/rancher/k3s/server/node-token /vagrant/