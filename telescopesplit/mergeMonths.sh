#!/bin/bash
#echo 'type folder name containing files to merge ie. 2014-11' #run from dataset and just type month folder's name ie 2014-11
#read dName
telescope=$1
dName=$2
place=`pwd`/${telescope}/${dName:0:4}/${dName}
cd ${place}
if [ ! -d ${place}/unmerged ]
	then
		mkdir ${place}/unmerged
fi
while [ `ls -1 | wc -l` -gt 2 ]
do
	for fileA in *
	do
		if [[ ${fileA: -5} == *.pcap ]]
			then
				echo 'file A: '${fileA}
				for fileB in *
				do
					if [[ ${fileB: -5} == *.pcap ]]
						then
							echo 'file B: '${fileB}
							if [[ ${fileA:0:7} == ${fileB:0:7} ]] && [[ ${fileA} != ${fileB} ]] #HERE!!!
								then
									mv ${fileA} ${place}/unmerged/${fileA}
									mv ${fileB} ${place}/unmerged/${fileB}
									mergecap -w ${fileB} unmerged/${fileA} unmerged/${fileB}
									editcap -F libpcap -dvv ${fileB} ${fileB:0:7}.ddup.pcap
								
							fi
					fi
				done
		fi
	done
done

