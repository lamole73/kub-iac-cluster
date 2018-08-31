#!/bin/bash

set -e
set -x

if [ -n "$(lsblk /dev/sdb | grep sdb1)" ]
then
 echo "Formating of disk already done, so skip."
 exit 0
fi

# Create Partition (sdb1) on disk
echo "Create Partition (sdb1) on disk"
sudo fdisk -u /dev/sdb <<EOF
n
p
1


w
EOF

# Format Partition (sdb1)
echo "Format Partition (sdb1)"
mkfs.ext4 /dev/sdb1
