#!/bin/bash

# This script is used to deploy common dependencies for Kubernetes installation.
# It performs the following tasks:
# 1. Updates and upgrades the system packages.
# 2. Disables swap.
# 3. Configures necessary kernel modules.
# 4. Configures sysctl settings.
# 5. Installs Docker and configures containerd.
# 6. Installs Kubernetes components (kubelet, kubeadm, kubectl).

export DEBIAN_FRONTEND=noninteractive

# Update and upgrade system packages
sudo apt update
sudo apt upgrade -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confold"

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Configure kernel modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl settings
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install Docker and configure containerd
sudo apt install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confold" curl gnupg2 software-properties-common apt-transport-https ca-certificates

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt -o Dpkg::Options::="--force-confold" install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confold" containerd.io

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# Install Kubernetes components
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main"

sudo apt update
sudo apt install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confold" kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



