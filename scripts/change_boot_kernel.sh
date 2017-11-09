#!/bin/sh

echo "=================================="
echo -e "1: identify current kernel version \n2: kernel lists \n3: set kernel \n4: exit" 
echo -e "==================================\n"

while [ : ]
do
	echo -n "input the value from 1 to 4 : "
	read input
	case $input in
		1)
			sudo grub2-editenv list;;
		2)
			sudo grep ^menuentry /etc/grub2-efi.cfg | cut -d "'" -f2;;
		3)	
			echo "Input kernel version: "
			read kernel
			sudo grub2-set-default "$kernel";;
		4)
			break;;
		*)
			echo "wrong input";;
	esac
done
