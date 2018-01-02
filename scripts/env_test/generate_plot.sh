#!/bin/bash

# type name [legacy log] [ms log]
if [ $# -lt 3 ]; then
	echo "Usage: ./generate_plot.sh [0:legacy|1:ms|2:both] [output_name] [legacy log file] [ms log file]"
	exit 1
fi

target_dir=/home/kau/dhkoo/fiotest/env_test

select=$1
name=$2
legacy_log=$3
ms_log=$4

#$1: 0:legacy; 1:ms
function calc_waf() 
{
	local ms=${1}

	if [ $ms -eq 1 ] ; then
		l_src=${target_dir}/${ms_log}
	else
		l_src=${target_dir}/${legacy_log}
	fi
	k=60
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
	if [ $ms -eq 1 ] ; then
	  echo "${k} ${waf}" >> ${target_dir}/${ms_log}_waf.log 
	else
	  echo "${k} ${waf}" >> ${target_dir}/${legacy_log}_waf.log 
	fi
	  k=`echo "${k} + 60" | bc`
	done 3<host_wr.txt 4<nand_wr.txt
	rm host_wr.txt nand_wr.txt
}

#$1: block size 
#$2: stream count
#$3: test type
function plot_legacy_waf()
{
cat << EOF >> ${target_dir}/waf.gp
   #!/usr/bin/gnuplot
   reset
   set terminal png enhanced size 1920,1200 
   set output "${target_dir}/${name}.png"
   set border linewidth 1
   set grid
   set key right center
   set xtics 3600
   set xlabel 'Time (secs)'
   set ylabel 'WAF'
   set yrange [0:5]
   set title 'WAF vs Time (secs)'
   set style line 1 linewidth 2 pointtype 1 pointsize 2 lc rgb "red"
   set style line 2 linewidth 2 pointtype 1 pointsize 2 lc rgb "blue"

   plot "${target_dir}/${legacy_log}_waf.log" using 1:2 notitle with points ls 1, 0/0 title "Legacy WAF" with lp ls 1 

EOF

   gnuplot=$(which gnuplot)
   $gnuplot ${target_dir}/waf.gp
}

function plot_ms_waf()
{
cat << EOF >> ${target_dir}/waf.gp
   #!/usr/bin/gnuplot
   reset
   set terminal png enhanced size 1920,1200 
   set output "${target_dir}/${name}.png"
   set border linewidth 1
   set grid
   set key right center
   set xtics 3600
   set xlabel 'Time (secs)'
   set ylabel 'WAF'
   set yrange [0:5]
   set title 'WAF vs Time (secs)'
   set style line 1 linewidth 2 pointtype 1 pointsize 2 lc rgb "red"
   set style line 2 linewidth 2 pointtype 1 pointsize 2 lc rgb "blue"

   plot "${target_dir}/${ms_log}_waf.log" using 1:2 notitle with points ls 2, 0/0 title "Multi-stream WAF" with lp ls 2

EOF

   gnuplot=$(which gnuplot)
   $gnuplot ${target_dir}/waf.gp
}
function plot_waf()
{
cat << EOF >> ${target_dir}/waf.gp
   #!/usr/bin/gnuplot
   reset
   set terminal png enhanced size 1920,1200 
   set output "${target_dir}/${name}.png"
   set border linewidth 1
   set grid
   set key right center
   set xtics 3600
   set xlabel 'Time (secs)'
   set ylabel 'WAF'
   set yrange [0:5]
   set title 'WAF vs Time (secs)'
   set style line 1 linewidth 2 pointtype 1 pointsize 2 lc rgb "red"
   set style line 2 linewidth 2 pointtype 1 pointsize 2 lc rgb "blue"

   plot "${target_dir}/${legacy_log}_waf.log" using 1:2 notitle with points ls 1, 0/0 title "Legacy WAF" with lp ls 1, \
   "${target_dir}/${ms_log}_waf.log" using 1:2 notitle with points ls 2, 0/0 title "Multi-stream WAF" with lp ls 2

EOF

   gnuplot=$(which gnuplot)
   $gnuplot ${target_dir}/waf.gp
}
if [ 0 -eq $select ]; then
	calc_waf 0
	plot_legacy_waf	
	rm -f ${target_dir}/${legacy_log}_waf.log
elif [ 1 -eq $select ]; then
	calc_waf 1
	plot_ms_waf
	rm -f ${target_dir}/${ms_log}_waf.log
elif [ 2 -eq $select ]; then
	calc_waf 0
	calc_waf 1
	plot_waf
	rm -f ${target_dir}/${legacy_log}_waf.log
	rm -f ${target_dir}/${ms_log}_waf.log
fi

rm -f ${target_dir}/waf.gp
#mv ${target_dir}/${name}.png ${target_dir}/png
