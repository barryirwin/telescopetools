#!/bin/bash

telescope=$1
month=$2
fname=$3
topx=$4
topx1=$((topx+1))
persum=0

cd ${telescope}/${month:0:4}/${month}
pwd
line=`cut -f 3 ${fname} | head -n ${topx1} | tail -n ${topx}`
for p in ${line}
	do
		perSum=`echo ${perSum} ${p} | awk '{print $1 + $2}'`
		#echo ${perSum}
done
echo 'total = '${perSum}'%'
