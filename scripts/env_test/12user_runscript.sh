#!/bin/sh

if [ "$#" -ne 13 ]; then
  echo "Useage:./runscript.sh [name] [quato1~12]"
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
mkdir /home/kau/dhkoo/mp/9
mkdir /home/kau/dhkoo/mp/10
mkdir /home/kau/dhkoo/mp/11
mkdir /home/kau/dhkoo/mp/12

#fio.py [sid] [user_id] 

cd /home/kau/dhkoo/mp/1
python ${shdir}/fio.py 0 1 &
python ${shdir}/fio.py 0 2 &
cd /home/kau/dhkoo/mp/2
python ${shdir}/fio.py 0 4 &
python ${shdir}/fio.py 0 5 &
cd /home/kau/dhkoo/mp/3
python ${shdir}/fio.py 0 7 &
python ${shdir}/fio.py 0 8 &
cd /home/kau/dhkoo/mp/4
python ${shdir}/fio.py 0 10 &
python ${shdir}/fio.py 0 11 &
cd /home/kau/dhkoo/mp/5
python ${shdir}/fio.py 0 13 &
python ${shdir}/fio.py 0 14 &
cd /home/kau/dhkoo/mp/6
python ${shdir}/fio.py 0 16 &
python ${shdir}/fio.py 0 17 &
cd /home/kau/dhkoo/mp/7
python ${shdir}/fio.py 0 19 &
python ${shdir}/fio.py 0 20 &
cd /home/kau/dhkoo/mp/8
python ${shdir}/fio.py 0 22 &
python ${shdir}/fio.py 0 23 &
cd /home/kau/dhkoo/mp/9
python ${shdir}/fio.py 0 3 &
python ${shdir}/fio.py 0 6 &
cd /home/kau/dhkoo/mp/10
python ${shdir}/fio.py 0 9 &
python ${shdir}/fio.py 0 12 &
cd /home/kau/dhkoo/mp/11
python ${shdir}/fio.py 0 15 &
python ${shdir}/fio.py 0 18 &
cd /home/kau/dhkoo/mp/12
python ${shdir}/fio.py 0 21 &
python ${shdir}/fio.py 0 24 &

${shdir}/deloldfiles.sh 1 $2 &
${shdir}/deloldfiles.sh 2 $3 &
${shdir}/deloldfiles.sh 3 $4 &
${shdir}/deloldfiles.sh 4 $5 &
${shdir}/deloldfiles.sh 5 $6 &
${shdir}/deloldfiles.sh 6 $7 &
${shdir}/deloldfiles.sh 7 $8 &
${shdir}/deloldfiles.sh 8 $9 &
${shdir}/deloldfiles.sh 9 $10 &
${shdir}/deloldfiles.sh 10 $11 &
${shdir}/deloldfiles.sh 11 $12 &
${shdir}/deloldfiles.sh 12 $13 &

sleep $runtime

pgrep fio.py | xargs kill 
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
rm -rf $checkdir/9
rm -rf $checkdir/10
rm -rf $checkdir/11
rm -rf $checkdir/12
