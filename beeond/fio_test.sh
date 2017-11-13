#!/bin/sh

sudo -u iouser1 $(which fio) job1.fio &
sudo -u iouser2 $(which fio) job2.fio &

wait
