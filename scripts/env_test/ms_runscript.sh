#!/bin/sh

if [ "$#" -ne 9 ]; then
  echo "Useage:./runscript.sh [name] [quota1~8]"
  exit 1
fi

shdir="/home/kau/dhkoo/fiotest/env_test"
checkdir="/home/kau/dhkoo/mp"
runtime=7200
NVME_BLKDEV="/dev/nvme2n1"

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
mkdir /home/kau/dhkoo/mp/2
mkdir /home/kau/dhkoo/mp/3
mkdir /home/kau/dhkoo/mp/4
mkdir /home/kau/dhkoo/mp/5
mkdir /home/kau/dhkoo/mp/6
mkdir /home/kau/dhkoo/mp/7
mkdir /home/kau/dhkoo/mp/8

#fio.py [sid] [user_id] 

cd /home/kau/dhkoo/mp/1
python ${shdir}/fio.py 1 1 &
python ${shdir}/fio.py 1 2 &
python ${shdir}/fio.py 1 3 &
cd /home/kau/dhkoo/mp/2
python ${shdir}/fio.py 2 4 &
python ${shdir}/fio.py 2 5 &
python ${shdir}/fio.py 2 6 &
cd /home/kau/dhkoo/mp/3
python ${shdir}/fio.py 3 7 &
python ${shdir}/fio.py 3 8 &
python ${shdir}/fio.py 3 9 &
cd /home/kau/dhkoo/mp/4
python ${shdir}/fio.py 4 10 &
python ${shdir}/fio.py 4 11 &
python ${shdir}/fio.py 4 12 &
cd /home/kau/dhkoo/mp/5
python ${shdir}/fio.py 5 13 &
python ${shdir}/fio.py 5 14 &
python ${shdir}/fio.py 5 15 &
cd /home/kau/dhkoo/mp/6
python ${shdir}/fio.py 6 16 &
python ${shdir}/fio.py 6 17 &
python ${shdir}/fio.py 6 18 &
cd /home/kau/dhkoo/mp/7
python ${shdir}/fio.py 7 19 &
python ${shdir}/fio.py 7 20 &
python ${shdir}/fio.py 7 21 &
cd /home/kau/dhkoo/mp/8
python ${shdir}/fio.py 8 22 &
python ${shdir}/fio.py 8 23 &
python ${shdir}/fio.py 8 24 &

${shdir}/deloldfiles.sh 1 $2 &
${shdir}/deloldfiles.sh 2 $3 &
${shdir}/deloldfiles.sh 3 $4 &
${shdir}/deloldfiles.sh 4 $5 &
${shdir}/deloldfiles.sh 5 $6 &
${shdir}/deloldfiles.sh 6 $7 &
${shdir}/deloldfiles.sh 7 $8 &
${shdir}/deloldfiles.sh 8 $9 &

sleep $runtime

pgrep fio.py | xargs kill -9
killall python
killall nmon
killall deloldfiles.sh

mv ${shdir}/waf.log ${shdir}/${1}.log
mv ${shdir}/cn10* ${shdir}/${1}.nmon

sleep 10
rm -rf $checkdir/1
rm -rf $checkdir/2
rm -rf $checkdir/3
rm -rf $checkdir/4
rm -rf $checkdir/5
rm -rf $checkdir/6
rm -rf $checkdir/7
rm -rf $checkdir/8
