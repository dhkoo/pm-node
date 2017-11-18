#!/bin/sh

inst="beegfs-storage"
bin_path="/opt/beegfs/sbin"
source_path="/home/kau/beegfs_stream/beegfs_storage/build"

make -j16 -C $source_path

## when at first
if [ -z $(ls -al $bin_path | grep lrwx) ]; then
	echo "[INFO] original ${inst} file exist"
	sudo mv ${bin_path}/${inst} ${bin_path}/origin_${inst}
	sudo ln -s ${source_path}/${inst} ${bin_path}/${inst}
	echo "[INFO] changed original ${inst} to origin_${inst} and made link"
fi

