#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Useage:./runscript.sh [name] [quato1]"
  exit 1
fi

shdir="/home/kau/dhkoo/fiotest/env_test"
checkdir="/home/kau/dhkoo/mp"
runtime=7200
NVME_BLKDEV=/dev/nvme2n1

function log_streams()
{
local rt=`echo "${runtime} / 60" | bc`
for i in `seq 1 $rt` ; do
        date && nvme_smart $NVME_BLKDEV
        sleep 60
done
}
function open_streams()
{
for i in `seq 1 $1`; do
        nvme_ms_ctrl $NVME_BLKDEV 1
        sleep 0.5
done
}
function close_streams()
{
for i in `seq 1 $1` ; do
        nvme_ms_ctrl $NVME_BLKDEV 2 $i
        sleep 0.5
done
}

open_streams 8
export LD_LIBRARY_PATH="/home/kau/dhkoo/Downloads/hdf5-1.8.9/hdf5/lib"

nmon -f -s 60 -c $runtime
(log_streams>>waf.log)&

mkdir /home/kau/dhkoo/mp/1

#fio.py [sid] [user_id] 

cd /home/kau/dhkoo/mp/1
python ${shdir}/fio.py 1 1 &
python ${shdir}/fio.py 1 2 &
python ${shdir}/fio.py 1 3 &
python ${shdir}/fio.py 1 13 &
python ${shdir}/fio.py 1 14 &
python ${shdir}/fio.py 1 15 &
python ${shdir}/fio.py 1 7 &
python ${shdir}/fio.py 1 8 &
python ${shdir}/fio.py 1 9 &
python ${shdir}/fio.py 1 19 &
python ${shdir}/fio.py 1 20 &
python ${shdir}/fio.py 1 21 &
python ${shdir}/fio.py 1 4 &
python ${shdir}/fio.py 1 5 &
python ${shdir}/fio.py 1 6 &
python ${shdir}/fio.py 1 16 &
python ${shdir}/fio.py 1 17 &
python ${shdir}/fio.py 1 18 &
python ${shdir}/fio.py 1 10 &
python ${shdir}/fio.py 1 11 &
python ${shdir}/fio.py 1 12 &
python ${shdir}/fio.py 1 22 &
python ${shdir}/fio.py 1 23 &
python ${shdir}/fio.py 1 24 &

${shdir}/deloldfiles.sh 1 $2 &

sleep $runtime

pgrep fio.py | xargs kill 
killall python
killall nmon
killall deloldfiles.sh

mv ${shdir}/waf.log ${shdir}/${1}.log
mv ${shdir}/cn10* ${shdir}/${1}.nmon

sleep 10
rm -rf $checkdir/1
