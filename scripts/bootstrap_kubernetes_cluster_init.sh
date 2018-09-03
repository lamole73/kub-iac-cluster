#!/bin/sh

set -e

# See: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

## Note: If you have already installed kubeadm, run apt-get update && apt-get upgrade or yum update to get the latest version of kubeadm.
## When you upgrade, the kubelet restarts every few seconds as it waits in a crashloop for kubeadm to tell it what to do. This crashloop is expected and normal. After you initialize your master, the kubelet runs normally.
# sudo yum update

## Initializing your master
echo "Initializing your master..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.10.27.81

#kubeadm join 10.10.27.81:6443 --token 40s1mc.nmrj3tjm4qutlh8p --discovery-token-ca-cert-hash sha256:4e27080adfc1df960e6f71e45dbd822ab27ebcbc5ae0df2a691758a66e52e77b

## To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:
echo "Make kubectl work for your non-root user..."
nonrootUser=vagrant
mkdir -p /home/$nonrootUser/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/$nonrootUser/.kube/config
sudo chown $(su - $nonrootUser -c 'id -u'):$(su - $nonrootUser -c 'id -g') /home/$nonrootUser/.kube/config

echo "Initializing your master... DONE"

## Installing a pod network add-on
echo "Installing a pod network add-on..."
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
su - $nonrootUser -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/c5d10c8/Documentation/kube-flannel.yml"
echo "Installing a pod network add-on... DONE"


## Master Isolation
## By default, your cluster will not schedule pods on the master for security reasons. If you want to be able to schedule pods on the master, e.g. for a single-machine Kubernetes cluster for development, run:
## kubectl taint nodes --all node-role.kubernetes.io/master-

