#!/bin/bash

if [ -z "$(lsblk /dev/sdb | grep sdb1)" ]
then
 echo "Partition sdb1 does not exist, so exit."
 exit 0
fi

TMP_MOUNT_LOCATION="$1"
[ "z$TMP_MOUNT_LOCATION" == "z" ] && TMP_MOUNT_LOCATION="/data/installations"

# Mount disk partition (sdb1) at #{disk_mount_point}
echo "Mount disk partition (sdb1) at $TMP_MOUNT_LOCATION"
mkdir -p $TMP_MOUNT_LOCATION
mount -t ext4 /dev/sdb1 $TMP_MOUNT_LOCATION

# Add second disk (sdb1) on /etc/fstab
echo "Add second disk (sdb1) on /etc/fstab"
printf "/dev/sdb1 $TMP_MOUNT_LOCATION ext4 defaults 0 0\n" | tee -a /etc/fstab

# If you want to manually run the commands use
# mkdir -p /data/installations
# mount -t ext4 /dev/sdb1 /data/installations
# printf "/dev/sdb1 /data/installations ext4 defaults 0 0\n" | tee -a /etc/fstab
