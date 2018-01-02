#!/bin/sh

if [ $# -ne 4 ]; then
	echo "./beeond_test.sh [ legacy | ms ] [option] [Ndevice] [target]"
  echo "option : 1,2 ( 1: start beeond, 2: stop beeond )"
	exit 1
fi

nodefile=""
pdir="/home/kau/pm-node/beeond"
target=$4

if [[ $3 -eq 1 ]]; then
   nodefile="nodefile1"
elif [[ $3 -eq 2 ]]; then
   nodefile="nodefile2"
elif [[ $3 -eq 4 ]]; then
   nodefile="nodefile4"
fi

if [ $2 -eq 1 ]; then
    if [[ $1 = "legacy" ]]; then
	      sudo beeond start -n ${pdir}/${nodefile} -d $target -c /mnt/beeond 
    elif [[ $1 = "ms" ]]; then
	      sudo beeond start -n ${pdir}/${nodefile} -d $target -c /mnt/beeond -x
    else
        echo "wrong input or empty string"
        exit 1
    fi
elif [ $2 -eq 2 ]; then
	sudo beeond stop -n ${pdir}/${nodefile} -L -d
else
	echo "wrong option number"
	exit 1
fi
