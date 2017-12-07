#!/bin/sh -x
script_path="/home/kau/pm-node/beeond"

#rm -f /mnt/beeond/io*
# ${script_path}/beeond_setting.sh 2
${script_path}/recompile_beegfs_storage_stream.sh | grep Error
rc=$?
if [[ $rc -eq 0 ]]; then # error occured!
    echo "complie error"
    exit 1
else
    echo "good"
fi

