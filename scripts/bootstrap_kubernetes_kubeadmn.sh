#!/bin/bash

set -e

# See: https://kubernetes.io/docs/setup/independent/install-kubeadm/
# To check if ubuntu or centos see: https://askubuntu.com/questions/459402/how-to-know-if-the-running-platform-is-ubuntu-or-centos-with-help-of-a-bash-scri

SCR_OS=$(awk -F= '/^NAME/{print toupper($2)}' /etc/os-release | tr -d \")
echo "OS script is running is: $SCR_OS"

## Install kubeadmn, kubelet, kubectl
echo "Installing kubeadmn, kubelet, kubectl..."

if [ "$SCR_OS" = "UBUNTU" ]
then
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

else
  #################################################
  ################ CENTOS
  #################################################

  cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
  setenforce 0
  yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
  systemctl enable kubelet && systemctl start kubelet
  
  ## Some users on RHEL/CentOS 7 have reported issues with traffic being routed incorrectly due to iptables being bypassed. You should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.
  cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
  sysctl --system
  
fi

#################################################
################ BOTH
#################################################

echo "Installing kubeadmn, kubelet, kubectl... DONE."
