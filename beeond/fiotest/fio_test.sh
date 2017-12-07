#!/bin/sh
#mkdir /mnt/beeond/kau
#mkdir /mnt/beeond/iouser1
#sudo chown iouser1:iouser1 /mnt/beeond/iouser1

#fio io1.fio &
sudo -u iouser1 $(which fio) io1.fio &
sudo -u iouser2 $(which fio) io2.fio &

wait
