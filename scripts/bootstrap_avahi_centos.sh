#!/bin/bash

set -e

# See: 

echo "Installing avahi..."
yum install -y avahi
systemctl enable avahi-daemon
systemctl start avahi-daemon

echo "Installing avahi... DONE."
