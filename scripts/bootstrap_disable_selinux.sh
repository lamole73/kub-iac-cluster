#!/bin/bash

set -e

echo "Current state of selinux"
sestatus

echo "Disabling selinux. Restart is required if 'Mode from config file' is changed."
# selinux Mode permissive
setenforce 0

# Disable selinux
# sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
#cat /etc/sysconfig/selinux

echo "Final state of selinux"
sestatus
