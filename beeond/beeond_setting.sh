#!/bin/sh

if [ $# -ne 1 ]; then
	echo "./beeond_test.sh [option]"
	echo "1 = start beeond"
	echo "2 = stop beeond"
	exit 1
fi

if [ $1 -eq 1 ]; then
	sudo beeond start -n nodefile -d /mnt/953 -c /mnt/beeond
elif [ $1 -eq 2 ]; then
	sudo beeond stop -n nodefile -L -d
else
	echo "wrong option number"
	exit 1
fi
