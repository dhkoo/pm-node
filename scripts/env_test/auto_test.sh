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
./1user_runscript.sh 80per_1users_ms_trimOn_fio 416
sleep 300
./auto_set.sh
sleep 10
./2user_runscript.sh 80per_2users_ms_trimOn_fio 200 216
sleep 300
./auto_set.sh
sleep 10
./4user_runscript.sh 80per_4users_ms_trimOn_fio 95 115 100 105

