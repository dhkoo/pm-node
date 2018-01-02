#!/bin/sh

input=$2
ratio=15

# delete files ( ratio of 15% )
rmfile=$(echo "${input}*${ratio}/6.4" | bc)
realsize=$(echo "${input}*1000000" | bc)

echo $rmfile
echo $realsize

