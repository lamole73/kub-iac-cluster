#!/bin/bash

set -e

# See: 

echo "Installing avahi..."
apt-get install -y avahi-daemon libnss-mdns
service avahi-daemon start

echo "Installing avahi... DONE."
