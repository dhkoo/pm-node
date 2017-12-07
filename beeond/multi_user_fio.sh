#!/bin/sh

sudo -u iouser1 /usr/local/bin/fio test.fio &
sudo -u iouser2 /usr/local/bin/fio test1.fio &
