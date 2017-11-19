#!/bin/sh

inst="beegfs-storage_stream"
bin_path="/opt/beegfs/sbin"
source_path="/home/kau/beegfs_stream/beegfs_storage/build"

make -j16 -C $source_path

if [ -e ${bin_path}/${inst} ]; then
  echo "compile done"
else
  echo "$(ls $bin_path | grep $inst)"
	echo "[INFO] original ${inst} file exist"
	sudo ln -s ${source_path}/beegfs-storage ${bin_path}/${inst}

	echo "complie done"
	echo "making symbolic link to beegfs-storage in beegfs_stream source"
fi

