#!/bin/sh

set -e

# See: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#join-nodes
# For automatic accept keys see: https://askubuntu.com/questions/123072/ssh-automatically-accept-keys

## Joining your nodes
## The nodes are where your workloads (containers and pods, etc) run. To add new nodes to your cluster do the following for each machine:
## SSH to the machine
## Become root (e.g. sudo su -)
## Run the command that was output by kubeadm init. For example:
## kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>

echo "Joining node $(hostname)..."

# get token and token hash from the cluster master
kub_cluster_token=$(sshpass -p 1 ssh -oStrictHostKeyChecking=no vagrant@10.10.27.81 kubeadm token list | sed '1d ; 3,$d' | awk '{print $1}')
kub_cluster_token_hash=$(sshpass -p 1 ssh vagrant@10.10.27.81 openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')

# join the node to the cluster
kubeadm join 10.10.27.81:6443 --token $kub_cluster_token --discovery-token-ca-cert-hash sha256:$kub_cluster_token_hash

echo "Joining node $(hostname)... DONE"

## Master Isolation
## By default, your cluster will not schedule pods on the master for security reasons. If you want to be able to schedule pods on the master, e.g. for a single-machine Kubernetes cluster for development, run:
## kubectl taint nodes --all node-role.kubernetes.io/master-

