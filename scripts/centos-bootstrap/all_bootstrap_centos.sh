#!/bin/bash

# exit upon error
set -e

SCR_LOC="$(dirname $(readlink -f $0))"
echo "script location: $SCR_LOC"

BS_HOSTNAME="hmrc857-single"
BS_USERNAME="root"
BS_PASSWORD="1"

BS_TARGET_FOLDER="/root/init-scripts"

echo "## SSH and install dos2unix"
sshpass -p "$BS_PASSWORD" ssh $BS_USERNAME@$BS_HOSTNAME yum install -y dos2unix

echo "## SSH and create target folder $BS_TARGET_FOLDER"
sshpass -p "$BS_PASSWORD" ssh $BS_USERNAME@$BS_HOSTNAME mkdir -p $BS_TARGET_FOLDER

# Copy full-deploy scripts
echo "## SSH and Copy scripts on target folder $BS_TARGET_FOLDER"
sshpass -p "$BS_PASSWORD" scp -r $SCR_LOC/* $BS_USERNAME@$BS_HOSTNAME:$BS_TARGET_FOLDER
# Make scripts executable on target folder on remote
sshpass -p "$BS_PASSWORD" ssh $BS_USERNAME@$BS_HOSTNAME "chmod +x $BS_TARGET_FOLDER/*.sh && dos2unix $BS_TARGET_FOLDER/*.sh"

echo "## SSH and run scripts"
sshpass -p "$BS_PASSWORD" ssh $BS_USERNAME@$BS_HOSTNAME "$BS_TARGET_FOLDER/bootstrap_disable_selinux.sh && $BS_TARGET_FOLDER/bootstrap_mount_sdb1.sh && $BS_TARGET_FOLDER/bootstrap_guestadditions_centos_redhat.sh"
