#!/bin/bash

TMP_NETBIOS_NAME=${1:-"hmrc857-single"}

echo "Installing samba..."
yum install -y samba samba-client samba-common
cp -pf /etc/samba/smb.conf /etc/samba/smb.conf.bak
echo "
# see smb.conf.example for a more detailed config file or
# read the smb.conf manpage.
# Run 'testparm' to verify the config is correct after
# you modified it.
[global]
workgroup = WORKGROUP
server string = Samba Server %v
# netbios name = $TMP_NETBIOS_NAME
security = user
map to guest = bad user
dns proxy = no
#====================== Share Definitions =========================
[DMS]
path = /dms
browsable =yes
writable = yes
guest ok = yes
read only = no
valid users = @smbgroup
[ROOT]
path = /root
browsable =yes
writable = yes
guest ok = no
read only = no
valid users = @smbgroup
" > /etc/samba/smb.conf
echo "Creating group smbgroup and add root on group..."
groupadd smbgroup
usermod -a -G smbgroup root
(echo 1; echo 1) | smbpasswd -a root
echo "Creating /dms folder to be shared by samba..."
mkdir -p /dms
chmod ugo+rw /dms
echo "Creating user dms with password 'dms' for samba..."
useradd dms -s /bin/bash -m -g smbgroup -G smbgroup
echo dms:dms | sudo chpasswd
(echo dms; echo dms) | smbpasswd -a dms
echo "Restarting samba services..."
systemctl restart smb.service
systemctl restart nmb.service
echo "Make run on startup samba services..."
systemctl enable smb.service
systemctl enable nmb.service
