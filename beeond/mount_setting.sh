#!/bin/sh

./beeond_setting.sh 2
umount /mnt/953
nvme_format_ns /dev/nvme2n1 0 0 1
mkfs.ext4 /dev/nvme2n1
mount -o acl,user_xattr /dev/nvme2n1 /mnt/953
./beeond_setting.sh 1
