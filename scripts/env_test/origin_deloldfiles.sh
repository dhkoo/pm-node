#!/bin/sh


if [ "$#" -ne 2 ]; then
  echo "Usage: ./deloldfiles.sh [stream id] [size]"
  exit 1
fi

input=$2
ratio=15 # delete ratio

# delete files ( ratio of 15% )
rmfile=$(echo "${input}*${ratio}/6.4" | bc)
inputKBsize=$(echo "${input}*1000000" | bc)

while true; do
  if [ -d "/home/kau/dhkoo/mp/$1" ]; then
    cd /home/kau/dhkoo/mp/$1
    size=`du -s | cut -f 1`
    if [ "$size" -gt "$inputKBsize" ]; then
      echo remove $1
      ls -t | tail -${rmfile}  | xargs rm -rf
    else
      sleep 5
    fi
  else
    sleep 10
    exit 1
  fi
done
