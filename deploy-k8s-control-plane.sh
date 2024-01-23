#!/bin/bash

# This script initializes a Kubernetes control plane using kubeadm.
# It creates the necessary configuration files and sets up the kubeconfig for the current user.
# After the control plane is initialized, it verifies the nodes using the 'kubectl get nodes' command.

sudo kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes


