#!/bin/bash

#echo "what file would you like to produce unique counts for?"
#read fname
telescope=$1
month=$2
fname=$3
port=$4
dname=${fname:: -4}'dstUniqExcl'${port}'.txt'
originalDir=`pwd`
cd ${telescope}/${month:0:4}/${month}
pwd
echo "" > ${dname}


#cut -f 1 ${fname} > ${dname}
while read line
	do
		#echo `awk '{ print $3 }' < ${line}`
		set -- ${line}
		if [[ `echo $3` != ${port} ]]
			then
				echo -e $1 >> ${dname}
		fi
done <${fname}

python ${originalDir}/cntUnique.py ${fname} ${dname}
