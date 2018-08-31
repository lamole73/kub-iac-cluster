#!/bin/bash

TMP_GUESTADDITIONS_VERSION=5.2.12
TMP_LOCATION=/data/installations/guestadditions
mkdir -p $TMP_LOCATION

echo "Install prerequises for guest additions and usefull utils"
# Usefull
yum -y install unzip
yum -y install wget
# Required by DB2 10.1 / 9.7 (32 bit version of libstdc++.so.6)
yum -y install libstdc++.i686
# Prerequises
yum -y install bzip2
# yum install -y kernel-devel-3.10.0-327.36.1.el7.x86_64

# yum update kernel*
# Then a reboot is needed, and then
yum install -y kernel-devel-`uname -r`
yum install -y gcc

echo "Download vbox guest additions if required"
cd $TMP_LOCATION
[ -f VBoxGuestAdditions_$TMP_GUESTADDITIONS_VERSION.iso ] || curl -O http://download.virtualbox.org/virtualbox/$TMP_GUESTADDITIONS_VERSION/VBoxGuestAdditions_$TMP_GUESTADDITIONS_VERSION.iso

echo "Install vbox guest additions"
sudo mount VBoxGuestAdditions_$TMP_GUESTADDITIONS_VERSION.iso -o loop /mnt
cd /mnt
sh VBoxLinuxAdditions.run --nox11

cd $TMP_LOCATION
umount /mnt
#rm -f /tmp/VBoxGuestAdditions_5.0.30.iso

#echo "Cleanup yum"
#yum clean all

# From mounted:
# https://www.if-not-true-then-false.com/2010/install-virtualbox-guest-additions-on-fedora-centos-red-hat-rhel/
# Mount GuestAdditions.iso vi VirtualBox UI
# mkdir /media/VirtualBoxGuestAdditions
# mount -r /dev/cdrom /media/VirtualBoxGuestAdditions
# sudo -i
# cd /media/VirtualBoxGuestAdditions
# ./VBoxLinuxAdditions.run
