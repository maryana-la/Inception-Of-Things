#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
curl -sfL https://get.k3s.io | sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

while [ ! -f /vagrant/confs/manifest.yaml ]; do
	echo "Waiting for manifest.yaml to be available..."
	sleep 10
      done

sudo kubectl apply -f /vagrant/confs/manifest.yaml


