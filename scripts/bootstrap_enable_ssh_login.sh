#!/bin/bash

set -e

echo "enable ssh login..."
sed -i 's|^ChallengeResponseAuthentication no.*|ChallengeResponseAuthentication yes|' /etc/ssh/sshd_config
echo "restarting sshd..."
systemctl restart sshd