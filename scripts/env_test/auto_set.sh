#!/bin/sh

umount /home/kau/dhkoo/mp
sleep 1
/home/kau/dhkoo/fiotest/ssdclean.sh
sleep 1
mkfs.ext4 /dev/nvme2n1
#tune2fs -O ^has_journal /dev/nvme2n1
#e2fsck -f /dev/nvme2n1
sleep 1
mount -o defaults,discard /dev/nvme2n1 /home/kau/dhkoo/mp
#mount /dev/nvme2n1 /home/kau/dhkoo/mp
