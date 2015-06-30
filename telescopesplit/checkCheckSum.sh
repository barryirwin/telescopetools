#!/bin/bash
#echo 'what year would you like to check checksums for? ie. 2014'
origin=`pwd`
#read year
telescope=$1
year=$2
cd ${telescope}/${year}
echo `pwd`
for type in md5 sha1 sha256
do
	textfile=checksum.${type}
	while read line
	do
		#echo ${line}
		#echo ${line#*' '}
		#if [[ ${line#*' '} == ${year}'-'* ]]
		#	then
		file=${line#*' '}
		file=${file:1}
		#else
		#	while 
		#		[[ ${file} != ${year}'-'* ]]
		#	do
		#		file=${file#*' '}
		#	done
		#fi
		folder=${file:0:7}
		echo 'Checking file:'${file}' in folder:'${folder}
		#echo 'pwd:'`pwd`
		if [[ `pwd` == ${origin} ]]
			then
				cd ${telescope}/${year}
		fi
		cd ${folder}
		#echo 'pwd:'`pwd`
		check=`${type}'sum' ${file}`
		if [[ ${check} == ${line} ]]
			then
				echo 'checksum.'${type}' is correct for '${file}
		fi
		cd ..
	done <${textfile}


done
	

