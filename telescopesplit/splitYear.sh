#!/bin/bash
folderdirectory=$1'/*'
foldername=`echo ${folderdirectory::-2} | rev | cut -d "/" -f1 | rev`
echo ${foldername}
if [ ! -d ${foldername} ]
	then
		mkdir ${foldername}
fi
for f in ${folderdirectory}
do
	echo 'file '${f}	
	first=`/usr/sbin/tcpdump -ttttnnr ${f} | head -n 1`
	startyear=${first:0:4}
	endyear=$((startyear+1))
	second=`/usr/sbin/tcpdump -ttttnnr ${f} | tail -n 1`
	stopyear=${second:0:4}
	let "stopyear++"
	place=`pwd`
	while
		[[ ${startyear} -lt ${stopyear} ]]
	do
		echo ${startyear}
		if [ ! -d ${place}/${foldername}/${startyear} ]
			then
				mkdir ${place}/${foldername}/${startyear}
		fi
		sfilename=${startyear}.pcap
		new=false
		while
			[[ ${new} == false ]]
		do
			if [ -f ${place}/${foldername}/${startyear}/${sfilename} ]
				then
					if [[ ${sfilename} == ${startyear}.pcap ]]
						then
							sfilename=${sfilename%.*}'_1.'${sfilename#*.}
					else
						i=${sfilename#*_}
						i=${i%.*}
						let "i++"
						#echo ${i}
						sfilename=${sfilename%_*}'_'${i}'.'${sfilename#*.}
					fi
			else
				new=true
			fi
		done
		editcap -F libpcap -A ${startyear}'-01-01 00:00:00' -B ${endyear}'-01-01 00:00:00' ${f} ${place}/${foldername}/${startyear}/${sfilename}
		#if [ ! -f ${place}/splitMonths.sh ]
		#	then
		#		cp splitMonths.sh ${place}/splitMonths.sh
		#fi
		let "startyear++"
		let "endyear++"
	done
done
