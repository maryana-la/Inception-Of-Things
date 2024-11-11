#!/bin/bash

uninstall_package() {
    local package_name=$1
    if command -v $package_name &> /dev/null; then
        echo "Removing $package_name..."
        if [ "$package_name" == "docker" ]; then
            sudo apt-get remove --purge -y docker docker-engine docker.io containerd runc
            sudo rm -rf /var/lib/docker
            sudo rm -rf /etc/docker
            sudo groupdel docker
        elif [ "$package_name" == "k3d" ]; then
            k3d cluster delete --all
            sudo rm -rf /usr/local/bin/k3d
        elif [ "$package_name" == "kubectl" ]; then
            sudo rm -f /usr/local/bin/kubectl
        elif [ "$package_name" == "argocd" ]; then
            sudo rm -f /usr/local/bin/argocd
        fi
        echo "$package_name removed successfully."
    else
        echo "$package_name is not installed."
    fi
}

uninstall_package "docker"

uninstall_package "k3d"

uninstall_package "kubectl"

uninstall_package "argocd"

echo "Uninstallation completed."
