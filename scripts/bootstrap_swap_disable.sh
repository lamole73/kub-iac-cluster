#!/bin/sh

# Disable swap for the running session
echo 'Disable swap for the running session...'
swapoff -a

# Disable swap permenantly
echo 'Disable swap permenantly...'
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# output results to terminal
df -h
cat /proc/swaps
cat /proc/meminfo | grep Swap
