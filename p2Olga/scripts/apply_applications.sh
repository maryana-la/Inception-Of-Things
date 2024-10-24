#!/bin/bash

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

while [ ! -f /vagrant/confs/applications.yaml ]; do
  echo "Waiting for applications.yaml to be available..."
  sleep 2
done

kubectl apply -f /vagrant/confs/applications.yaml
