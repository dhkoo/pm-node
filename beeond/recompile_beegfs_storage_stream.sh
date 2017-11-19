#!/bin/sh

inst="beegfs-storage_stream"
bin_path="/opt/beegfs/sbin"
source_path="/home/kau/beegfs_stream/beegfs_storage/build"

make -j16 -C $source_path

if [ -e ${bin_path}/${inst} ]; then
  echo "[Compile done]"
else
  echo "maybe It's first time"
  sudo mv ${bin_path}/beeond ${bin_path}/origin_beeond
  sudo ln -s /home/kau/beegfs_stream/beeond/source/beeond ${bin_path}/beeond
  echo "$(ls $bin_path | grep $inst)"
	sudo ln -s ${source_path}/beegfs-storage ${bin_path}/${inst}

	echo "[complie done]"
	echo "[beeond -> origin_beeond and symbolic link beeond modified by dhkoo]"
	echo "[making symbolic link to beegfs-storage in beegfs_stream source]"
fi

