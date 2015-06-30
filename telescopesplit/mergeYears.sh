#!/bin/bash
telescope=$1
dName=$2
place=`pwd`/${dName}
cd ${telescope}/${place}
if [ ! -d ${telescope}/${place}/unmerged ]
	then
		mkdir ${telescope}/${place}/unmerged
fi
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
						if [[ ${fileA:0:4} == ${fileB:0:4} ]] && [[ ${fileA} != ${fileB} ]] #HERE!!!
							then
								mv ${fileA} ${telescope}/${place}/unmerged/${fileA}
								mv ${fileB} ${telescope}/${place}/unmerged/${fileB}
								mergecap -w ${fileB} unmerged/${fileA} unmerged/${fileB}
								editcap -dvv ${fileB} ${fileB:0:4}.ddup.pcap				
						fi
				fi
			done
	fi
done
