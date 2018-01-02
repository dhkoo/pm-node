#!/bin/sh

if [[ $(whoami) != "root" ]]; then
    echo "[error] Only execute by root"
    exit 1
fi

function node_setting()
{
remote_cmd="ssh root@${1}"

$remote_cmd umount /mnt/953
$remote_cmd /home/kau/multi_stream/tools/nvme-user/nvme_format_ns /dev/nvme1n1 0 0 1 > /dev/null 2>&1
$remote_cmd mkfs.ext4 /dev/nvme1n1 > /dev/null 2>&1
$remote_cmd mount -o discard,acl,user_xattr /dev/nvme1n1 /mnt/953
echo "${1} setting done"
}


node_setting pm003 &
node_setting pm004 &

wait
echo "[INFO] you can start beeond"

