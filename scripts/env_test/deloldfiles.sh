#!/bin/sh


if [ "$#" -ne 2 ]; then
  echo "Usage: ./deloldfiles.sh [path id] [size]"
  exit 1
fi

pathid=$1
input=$2
ratio=15 # delete ratio
target="/mnt/beeond"

# delete files ( ratio of 15% )
rmfile=$(echo "${input}*${ratio}/6.4" | bc)
inputKBsize=$(echo "${input}*1000000" | bc)

while true; do
  if [ -d "${target}/${pathid}" ]; then
    cd ${target}/${pathid}
    size=`find . -printf %k"\n" | awk '{  sum += $1 } END { print sum }'`
    echo $pathid : $size
    if [ "$size" -gt "$inputKBsize" ]; then
      echo remove $pathid
      ls -t | tail -${rmfile}  | xargs rm -rf
    else
      sleep 5
    fi
  else
    sleep 10
    exit 1
  fi
done
