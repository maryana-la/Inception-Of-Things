#!/bin/bash

while [ ! -f /vagrant/node-token ]; do
  sleep 2
done
sudo apt-get update -y
sudo apt-get install -y curl
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip 192.168.56.111" K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$(cat /vagrant/node-token) sh -
rm /vagrant/node-token