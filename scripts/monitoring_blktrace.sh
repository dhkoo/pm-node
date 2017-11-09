#!/bin/sh

if [ $# -ne 1 ]; then
	echo " ./monitoring_blktrace.sh [r: recording | m: monitoring]"
	exit 1
fi

target="/dev/nvme0n1"

if [ $1 = r ]; then
	read -p "filename : " name
	sudo blktrace -d $target -o - | blkparse -i - >> $name
elif [ $1 = m ]; then
	sudo blktrace -d $target -o - | blkparse -i - 
else
	echo " wrong input"
fi
