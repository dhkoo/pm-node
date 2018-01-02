#!/bin/sh

if [ "$#" -ne 3 ]; then
  echo "Useage:./gc_waf_runscript.sh [legacy | ms] [name] [# of nums]"
  exit 1
fi

shdir="$(pwd)"
beeond="/mnt/beeond"
runtime=3600
NVME_BLKDEV="/dev/nvme1n1"
nums=$3

quota1=9
quota2=11
quota3=12
quota4=14
quota5=16
quota6=20
quota7=21
quota8=24
quota9=24
quota10=27
quota11=29
quota12=32
quota13=34
quota14=36
quota15=37
quota16=39

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
remote_cmd="ssh root@pm004"

if [[ $2 = "remote" ]]; then
    for i in `seq 1 $1`; do
        $remote_cmd LD_LIBRARY_PATH=/opt/glibc-2.14/lib /home/kau/multi_stream/tools/nvme-user/nvme_ms_ctrl $NVME_BLKDEV 1
        sleep 0.5
    done
else
    for i in `seq 1 $1`; do
        nvme_ms_ctrl $NVME_BLKDEV 1
        sleep 0.5
    done
fi
}

for i in $(seq 1 16)
do
    mkdir ${beeond}/${i}
done

if [[ $nums -eq 1 ]]; then
    if [[ $1 == "ms" ]]; then
        open_streams 16 "local"
    fi
elif [[ $nums -eq 2 ]]; then
    if [[ $1 == "ms" ]]; then
        open_streams 16 "local"
        open_streams 16 "remote"
        ssh root@pm004 /home/kau/dhkoo/nmon_files/gc_waf/start_nmon_waf.sh $1 $runtime $2 &
    fi
elif [[ $nums -eq 4 ]]; then
    if [[ $1 == "ms" ]]; then
        echo "hello"
    fi
fi

nmon -f -s 60 -c $runtime
(log_streams>>waf.log)&

#fio.py [sid] [user_id] 

if [[ $nums -eq 4 ]] || [[ $nums -eq 2 ]] || [[ $nums -eq 1 ]]; then
    cd ${beeond}/1
    python ${shdir}/fio.py 0 1 &
    #python ${shdir}/fio.py 0 2 &
    cd ${beeond}/2
    python ${shdir}/fio.py 0 4 &
    #python ${shdir}/fio.py 0 5 &
    cd ${beeond}/3
    python ${shdir}/fio.py 0 5 &
    #python ${shdir}/fio.py 0 6 &
    cd ${beeond}/4
    python ${shdir}/fio.py 0 7 &
    #python ${shdir}/fio.py 0 8 &
fi

if [[ $nums -eq 2 ]] || [[ $nums -eq 1 ]]; then
    cd ${beeond}/5
    python ${shdir}/fio.py 0 9 &
    #python ${shdir}/fio.py 0 10 &
    cd ${beeond}/6
    python ${shdir}/fio.py 0 11 &
    #python ${shdir}/fio.py 0 12 &
    cd ${beeond}/7
    python ${shdir}/fio.py 0 13 &
    #python ${shdir}/fio.py 0 14 &
    cd ${beeond}/8
    python ${shdir}/fio.py 0 15 &
    #python ${shdir}/fio.py 0 16 &
fi

if [[ $nums -eq 1 ]]; then
    cd ${beeond}/9
    python ${shdir}/fio.py 0 17 &
    #python ${shdir}/fio.py 0 18 &
    cd ${beeond}/10
    python ${shdir}/fio.py 0 19 &
    #python ${shdir}/fio.py 0 20 &
    cd ${beeond}/11
    python ${shdir}/fio.py 0 21 &
    #python ${shdir}/fio.py 0 22 &
    cd ${beeond}/12
    python ${shdir}/fio.py 0 23 &
    #python ${shdir}/fio.py 0 24 &
    cd ${beeond}/13
    python ${shdir}/fio.py 0 25 &
    #python ${shdir}/fio.py 0 26 &
    cd ${beeond}/14
    python ${shdir}/fio.py 0 27 &
    #python ${shdir}/fio.py 0 28 &
    cd ${beeond}/15
    python ${shdir}/fio.py 0 29 &
    #python ${shdir}/fio.py 0 30 &
    cd ${beeond}/16
    python ${shdir}/fio.py 0 31 &
    #python ${shdir}/fio.py 0 32 &
fi

if [[ $nums -eq 1 ]]; then
    ${shdir}/deloldfiles.sh 1 $((${quota1}*${nums})) &
    ${shdir}/deloldfiles.sh 2 $((${quota2}*${nums})) &
    ${shdir}/deloldfiles.sh 3 $((${quota3}*${nums})) &
    ${shdir}/deloldfiles.sh 4 $((${quota4}*${nums})) &
    ${shdir}/deloldfiles.sh 5 $((${quota5}*${nums})) &
    ${shdir}/deloldfiles.sh 6 $((${quota6}*${nums})) &
    ${shdir}/deloldfiles.sh 7 $((${quota7}*${nums})) &
    ${shdir}/deloldfiles.sh 8 $((${quota8}*${nums})) &
    ${shdir}/deloldfiles.sh 9 $((${quota9}*${nums})) &
    ${shdir}/deloldfiles.sh 10 $((${quota10}*${nums})) &
    ${shdir}/deloldfiles.sh 11 $((${quota11}*${nums})) &
    ${shdir}/deloldfiles.sh 12 $((${quota12}*${nums})) &
    ${shdir}/deloldfiles.sh 13 $((${quota13}*${nums})) &
    ${shdir}/deloldfiles.sh 14 $((${quota14}*${nums})) &
    ${shdir}/deloldfiles.sh 15 $((${quota15}*${nums})) &
    ${shdir}/deloldfiles.sh 16 $((${quota16}*${nums})) &
elif [[ $nums -eq 2 ]]; then
    ${shdir}/deloldfiles.sh 1 $((${quota1}*${nums})) &
    ${shdir}/deloldfiles.sh 2 $((${quota2}*${nums})) &
    ${shdir}/deloldfiles.sh 3 $((${quota3}*${nums})) &
    ${shdir}/deloldfiles.sh 4 $((${quota4}*${nums})) &
    ${shdir}/deloldfiles.sh 5 $((${quota5}*${nums})) &
    ${shdir}/deloldfiles.sh 6 $((${quota6}*${nums})) &
    ${shdir}/deloldfiles.sh 7 $((${quota7}*${nums})) &
    ${shdir}/deloldfiles.sh 8 $((${quota8}*${nums})) &
elif [[ $nums -eq 4 ]]; then
    ${shdir}/deloldfiles.sh 1 $((${quota1}*${nums})) &
    ${shdir}/deloldfiles.sh 2 $((${quota2}*${nums})) &
    ${shdir}/deloldfiles.sh 3 $((${quota2}*${nums})) &
    ${shdir}/deloldfiles.sh 4 $((${quota2}*${nums})) &
fi

sleep $runtime

pgrep fio.py | xargs kill 
killall python
killall nmon
killall deloldfiles.sh

mv ${shdir}/waf.log ${shdir}/${2}_${1}_${3}.log
mv ${shdir}/pm003* ${shdir}/${2}_${1}_${3}.nmon

sleep 10

for i in $(seq 1 16)
do
    rm -rf ${beeond}/$i &
done

wait

echo "test is done"
