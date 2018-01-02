import sys
import os
import time

i = 1

while True:
	#os.system("fio --name=global --rw=write --direct=0 --iodepth=128 --ioengine=sync --bs=4k --group_reporting --file_service_type=random --fill_fs=1 --fadvise_stream="+sys.argv[1]+" --name=chk_"+sys.argv[2]+"_"+str(i)+" --size=64m --name=plt_"+sys.argv[2]+"_"+str(i)+" --size=64m > /dev/null")
	os.system("fio --name=global --rw=write --direct=0 --iodepth=128 --ioengine=sync --bs=4m --group_reporting --file_service_type=random --fill_fs=1 --fadvise_stream="+sys.argv[1]+" --name=file_"+sys.argv[2]+"_"+str(i)+" --size=64m > /dev/null")
	i = i+1
