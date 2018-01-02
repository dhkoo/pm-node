#!/bin/bash

if [ $# -ne 1  ]; then
    echo "./waf_calc.sh [file]"
	  exit 1
fi


file=$1

function calc_waf() 
{
  l_src=$(pwd)/${file}

	k=60
  sum=0
  count=0
        grep "^data_units_written" ${l_src} | awk '{print $4}' | awk -F"(" '{print $2}'| awk -F")" '{print $1}' > host_wr.txt
        grep "^nand_data_units_written" ${l_src} | awk '{print $4}' | awk -F"(" '{print $2}'| awk -F")" '{print $1}' > nand_wr.txt

	read -r host_wr_before <host_wr.txt 
	read -r nand_wr_before <nand_wr.txt
	while true
	do
	  read -r host_wr_after <&3 || break
	  read -r nand_wr_after <&4 || break

	  if (($host_wr_before == $host_wr_after)) && (($nand_wr_before == $nand_wr_after)) ; then
	     read -r host_wr_after <&3 || break
	     read -r nand_wr_after <&4 || break
	  fi

	  waf=`echo "scale=3; (${nand_wr_after}-${nand_wr_before})/(${host_wr_after}-${host_wr_before})" | bc`
	  host_wr_before=$host_wr_after
	  nand_wr_before=$nand_wr_after

	  #echo "${k} ${waf}" >> $(pwd)/waf_sequence
	  k=`echo "${k} + 60" | bc`
	  sum=`echo "${sum} + ${waf}" | bc`
	  count=`echo "${count} + 1" | bc`

	done 3<host_wr.txt 4<nand_wr.txt
	rm host_wr.txt nand_wr.txt
  echo "Average WAF : `echo "scale=3; ${sum}/${count}" | bc -l`"
  echo $sum $count
}

calc_waf
