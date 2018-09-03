#!/bin/sh

set -e

# See: https://kubernetes.io/docs/setup/independent/install-kubeadm/

## Install kubeadmn, kubelet, kubectl
echo "Installing kubeadmn, kubelet, kubectl..."

#################################################
################ UBUNTU
#################################################
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


#################################################
################ CENTOS
#################################################

#cat <<EOF > /etc/yum.repos.d/kubernetes.repo
#[kubernetes]
#name=Kubernetes
#baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
#enabled=1
#gpgcheck=1
#repo_gpgcheck=1
#gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
#exclude=kube*
#EOF
#setenforce 0
#yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
#systemctl enable kubelet && systemctl start kubelet
#
### Some users on RHEL/CentOS 7 have reported issues with traffic being routed incorrectly due to iptables being bypassed. You should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.
#cat <<EOF >  /etc/sysctl.d/k8s.conf
#net.bridge.bridge-nf-call-ip6tables = 1
#net.bridge.bridge-nf-call-iptables = 1
#EOF
#sysctl --system
#

#################################################
################ BOTH
#################################################

echo "Installing kubeadmn, kubelet, kubectl... DONE."
