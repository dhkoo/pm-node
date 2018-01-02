#!/bin/sh

# 30%
# quota1 : 16 16 16 16 16 16 16 16
# quota2 : 13 19 14 18 15 17 16 16
# quota3 : 8 8 12 12 15 16 20 37 

# 50%
# quota1 : 30 30 30 30 30 30 30 30 
# quota2 : 26 28 29 30 30 31 32 34
# quota3 : 10 10 18 23 28 34 48 62

# 80%
# quota1 : 52 52 52 52 52 52 52 52
# quota2 : 50 54 48 56 52 52 46 60
# quota3 : 10 10 35 45 65 70 80 95

./auto_set.sh
sleep 10
./ms_runscript.sh 80per_quota2_ms_trimOn_fio 50 54 48 56 52 52 46 60
sleep 300
./auto_set.sh
sleep 10
./ms_runscript.sh 80per_quota1_ms_trimOn_fio 52 52 52 52 52 52 52 52
sleep 300
./auto_set.sh
sleep 10
./ms_runscript.sh 50per_quota3_ms_trimOn_fio 10 10 18 23 28 34 48 62
sleep 300
./auto_set.sh
sleep 10
./ms_runscript.sh 50per_quota2_ms_trimOn_fio 26 28 29 30 30 31 32 34
sleep 300
./auto_set.sh
sleep 10
./ms_runscript.sh 50per_quota1_ms_trimOn_fio 30 30 30 30 30 30 30 30
sleep 300
./auto_set.sh
sleep 10
./ms_runscript.sh 30per_quota3_ms_trimOn_fio 8 8 12 12 15 16 20 37
sleep 300
./auto_set.sh
sleep 10
./ms_runscript.sh 30per_quota2_ms_trimOn_fio 13 19 14 18 15 17 16 16
sleep 300
./auto_set.sh
sleep 10
./ms_runscript.sh 30per_quota1_ms_trimOn_fio 16 16 16 16 16 16 16 16
