#!/bin/bash

set -e

echo "Installing Ansible..."
yum install -y epel-release
yum install -y ansible

echo "Installing python-jmespath..."
yum install -y python-jmespath

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
