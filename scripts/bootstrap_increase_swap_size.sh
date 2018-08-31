#!/bin/sh

# size of swapfile in megabytes
swapsize=2048

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
  echo 'swapfile not found. Adding swapfile.'
  # 1024 * 2048 MB = 2097152 chunks
  # 1024 * 512 MB = 524288 chunks
  # dd if=/dev/zero of=/swapfile bs=1024 count=524288
  dd if=/dev/zero of=/swapfile bs=1M count=512
  # fallocate -l ${swapsize}M /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
  echo 'swapfile found. No changes made.'
fi

# output results to terminal
df -h
cat /proc/swaps
cat /proc/meminfo | grep Swap
