#!/bin/bash

# Samsung Semiconductor 2015
# This is the benchmark script for multi-stream NVMe SSD. 
# Following test configurations are available (see "tests" variable in script below)
# Note that the ratio is calculated based on 4 write streams.
#    - w100r0: 100% of operations are write and no read operation
#    - w10r90: 10% of operations are write and 90% of operations are read
#    - w30r70: 30% of operations are write and 70% of operations are read
#    - w70r30: 70% of operations are write and 30% of operations are read
#    - w0r100: 100% of operations are read and no write operation
# For write operations, SSD is divided into number of partitions with different sizes based on number of streams.
# Individual write jobs operate on each partitions respectively to simulate data streams, each with different data lifetime.

# set of test configurations for different percentage of read/write mix based on 4 write streams.
# if you are uising anything other than 4 streams, the read/write ratio is no longer correct.
#tests="w100r0 w30r70 w70r30 w10r90 w0r100"
tests="w100r0"

# write block sizes
#bss="4k 8k 16k 32k 64k 128k 256k 512k 1M"
bss="128k"

# number of streams
sts=`seq 1 16`
sts="9"

# how long each benchmark will run (in sec)
runtime=`echo "8 * 60 * 60" | bc`

# stream boundary alignment
st_align=`echo "384 * 1024 * 1024" | bc`

# how long to the benchmark should run before logging
ramptime=0

if [ $# -ne 2 ]; then
	echo "Please specify nvme block device, e.g., "
	echo "$ $0 /dev/nvme0n1 <0|1> #0:legacy; 1:multi-stream "
	echo "WARNING!!! Make sure NOT to use your boot drive for this"
	exit 1
fi

# global
NVME_BLKDEV=$1

# run mode
MS=$2

# commands used in the script
sg_readcap=$(which sg_readcap)
nvme_format_ns=$(which nvme_format_ns)
nvme_ms_ctrl=$(which nvme_ms_ctrl)
nvme_smart=$(which nvme_smart)
fio=$(which fio)

# raw disk size
RAW_SIZE=$(sudo $sg_readcap $NVME_BLKDEV | grep size | awk '{print $3}')
echo "### $NVME_BLKDEV raw disk size is: $RAW_SIZE"

function run_precond()
{
#There are multiple ways how you can prepare the drive for the benchmarking. 
#Here are basic steps to follow to get reliable data at the end:

#1. Secure Erase SSD
echo "Secure Erase NVME SSD ..."
sudo $nvme_format_ns $NVME_BLKDEV 0 0 1

#2. Fill SSD with sequential data twice of it's capacity. This will gurantee all available 
#   memory is filled with a data including factory provisioned area. DD is the easiest way for this:
#   dd if=/dev/zero bs=1024k of=/dev/"devicename"
#echo "Fill SSD w/ sequential data ... loop 1"
#sudo dd if=/dev/zero bs=1M oflag=direct of=$NVME_BLKDEV 
#echo "Fill SSD w/ sequential data ... loop 2"
#sudo dd if=/dev/zero bs=1M oflag=direct of=$NVME_BLKDEV 

#3. If you're running sequential workload to estimate the read or write throughput then skip to next step.
#   Fill the drive with 4k random data. The same rule, total amount of data is twice drive's capacity.
#   Use FIO for this purpose. Here is an example script for NVMe SSD:
#	[global]
#	name=4k random write 4 ios in the queue in 32 queues
#	filename=/dev/nvme0n1
#	ioengine=libaio
#	direct=1
#	bs=4k
#	rw=randwrite
#	iodepth=4
#	numjobs=32
#	buffered=0
#	size=100%
#	loops=2	
#	[job1]
#echo "Fill SSD w/ random data"
#sudo fio --name=global --ioengine=libaio --iodepth=4 --rw=randwrite --bs=4k --direct=1 --filename $NVME_BLKDEV --size=100% --numjobs=1 --loops=2 --name=job1
 
#5. Run your workload. Usually meassurements starts after 5 minutes of runtime in order to let the SSD FW 
#   adopting to the workload. It's called sustained performance state. This time depends on the SSD 
#   Vendor/SKU/capacity.  
}

#$1: number of stream to open
function open_streams()
{
for i in `seq 1 $1`; do
	sudo $nvme_ms_ctrl $NVME_BLKDEV 1
	sleep 0.5 
done
}

#$1: number of stream to close
function close_streams()
{
for i in `seq 1 $1` ; do
	sudo $nvme_ms_ctrl $NVME_BLKDEV 2 $i
	sleep 0.5
done
}

function log_streams()
{
local rt=`echo "${runtime} / 60" | bc`
for i in `seq 1 $rt` ; do
        date && sudo $nvme_smart $NVME_BLKDEV 
        sleep 60
done
}

#$1: test type
#$2: 1:ms, 2:legacy
#$3: write block size 
#$4: number of streams
function run_test()
{
        t=$1
        ms=$2
        bs=$3
	st=$4
	
        w_=`echo $t | awk -Fr '{print $1}' | awk -Fw '{print $2}'`
        r_=`echo $t | awk -Fr '{print $2}'`

	FIO_OPTS_COMMON="--name=global --rw=write --bs=$bs --direct=1 --iodepth=1 --ioengine=libaio \
         --filename=$NVME_BLKDEV \
         --file_service_type=random \
         --time_based --runtime=$runtime \
         --group_reporting \
         --bandwidth-log=legacy \
         --output=fio_summary.log \
         --ramp_time=$ramptime "

	OFFSET_PREV=0
	BSIZE=`echo "${RAW_SIZE} / ${st} / ${st} / (${st_align}) * (${st_align})" | bc`
	echo "Base block size: $BSIZE"
	OFFSET=0
        FIO_OPTS_MS=" "
        FIO_OPTS_LEGACY=" "
	for i in `seq 1 $st` ; do
		SIZE=`echo "${BSIZE} * ( ${i} * 2 - 1 )" | bc`
		echo "Stream $i of $st size: $SIZE"
        	FIO_OPTS_MS="${FIO_OPTS_MS} \
         	   --name=seqwrite_job${i} --offset=$OFFSET --size=$SIZE --fadvise_stream=$i "
        	FIO_OPTS_LEGACY="${FIO_OPTS_LEGACY} \
         	   --name=seqwrite_job${1} --offset=$OFFSET --size=$SIZE --fadvise_stream=0 "
		OFFSET_PREV=`echo ${OFFSET} | bc`
		OFFSET=`echo ${OFFSET_PREV} + ${SIZE} | bc`
	done

	FIO_OPTS_RR=" \
	 --name=randread_job --rw=randread --bs=4k --size=100% --iodepth=32 "

	echo " "
	if [ $w_ -eq 0 ] ; then
        	echo "### Run Benchmark: $t "
		FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_RR --numjobs=4"
	else
        	echo -n "### Run Benchmark: $t "
        	if [ $ms -eq 1 ] ; then
                	echo " multistream mode"
	                if [ $r_ -eq 90 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_MS $FIO_OPTS_RR --numjobs=23"
                	elif [ $r_ -eq 70 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_MS $FIO_OPTS_RR --numjobs=6"
                	elif [ $r_ -eq 30 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_MS $FIO_OPTS_RR --numjobs=2"
                	elif [ $r_ -eq 0 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_MS"
                	fi
        	else
                	echo " legacy mode"
	                if [ $r_ -eq 90 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_LEGACY $FIO_OPTS_RR --numjobs=23"
                	elif [ $r_ -eq 70 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_LEGACY $FIO_OPTS_RR --numjobs=6"
                	elif [ $r_ -eq 30 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_LEGACY $FIO_OPTS_RR --numjobs=2"
                	elif [ $r_ -eq 0 ] ; then
				FIO_OPTS="$FIO_OPTS_COMMON $FIO_OPTS_LEGACY"
                	fi
        	fi
	fi
	echo "fio $FIO_OPTS"
	sudo $fio $FIO_OPTS
}

for bs in $bss; do
   mkdir -p $bs
   cd $bs
   for sn in $sts; do
      mkdir -p $sn
      cd $sn
      for _t in $tests; do
   	echo ""
   	echo "### Run FIO Benchmark with block size: ${bs}; stream count: ${sn}; test type: ${_t}"
	mkdir -p $_t
	cd $_t
       if [ $MS -eq 1 ] ; then
	mkdir -p ms
	cd ms
	run_precond && sleep 5
	open_streams $sn
	rm -rf smart_ms.log
	(log_streams>>smart_ms.log)&
	run_test $_t 1 $bs $sn
	close_streams $sn
        cd ..
       else
	mkdir -p legacy
	cd legacy
	run_precond && sleep 5
	rm -rf smart_legacy.log
	(log_streams>>smart_legacy.log)&
	run_test $_t 0 $bs $sn
	cd ..
       fi
      cd ..
      done
      cd ..
   done
   cd ..
done

