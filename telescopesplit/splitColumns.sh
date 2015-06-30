#!/bin/bash

#echo "what file would you like to produce unique counts for?"
#read fname
directory=$1
fname=`echo ${directory} | rev | cut -d "/" -f1 | rev`
echo ${fname}
dir=${directory%/*}
currentDir=`pwd`
cd ${currentDir}/${dir}
echo `pwd`
dname=${fname:: -4}'dstUniq.txt'
sname=${fname:: -4}'srcUniq.txt'
dpname=${fname:: -4}'dstPrtUniq.txt'
spname=${fname:: -4}'srcPrtUniq.txt'

#if [ ! -f ${dname} ]
#	 then
#		gedit ${dname}
#fi
#if [ ! -f ${sname} ]
#	then
#		gedit ${sname}
#fi

cut -f 1 ${fname} > ${dname}
cut -f 2 ${fname} > ${sname}
cut -f 3 ${fname} > ${dpname}
cut -f 4 ${fname} > ${spname}


python ${currentDir}/cntUnique.py ${dir} ${fname} ${dname} ${sname} ${dpname} ${spname}
