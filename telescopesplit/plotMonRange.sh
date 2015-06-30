#!/bin/bash

telescope=$1
month=$2
fname=$3
gname=$4
title=$5
mrt="monRangeTemp.txt"
cd ${telescope}/${month:0:4}/${month}
if [ -f monRangeTemp.txt ]
	then
		rm ${mrt}
fi
while read line
do
	line=`echo ${line} | cut -d '.' -f4-`
	line=`echo -e ${line%' '*}"\t"${line#*' '} >> ${mrt}`
done <${fname}

gnuplot <<- EOF
	set terminal postscript eps enhanced color font 'Helvetica,10'
	set output "${gname}"
	set xtics 16
	plot "${mrt}" u 1:2 smooth unique t "${title}" w lines
EOF

rm ${mrt}
