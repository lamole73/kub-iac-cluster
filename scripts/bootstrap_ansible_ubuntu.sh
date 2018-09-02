#!/bin/bash

set -e

echo "Installing Ansible..."
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible


echo "Generating RSA key for user vagrant."

rsa_private_key="/home/vagrant/.ssh/id_rsa"
rsa_public_key="/home/vagrant/.ssh/id_rsa.pub"
# if [ -f rsa_private_key ]; then do
#   ssh-keygen -t rsa -b 4096 -N '' -f ${rsa_private_key}
#   chown vagrant:vagrant ${rsa_private_key} ${rsa_public_key}
# fi

[[ -f ${rsa_private_key} ]] \
|| ssh-keygen -t rsa -b 4096 -N '' -f ${rsa_private_key} \
&& chown vagrant:vagrant ${rsa_private_key} ${rsa_public_key}
