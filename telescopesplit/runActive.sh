#!/bin/bash

telescope=$1
year=$2

cd ${telescope}/${year}

for mfolder in *
do
	if [ -d ${mfolder} ]
		then
			if [[ ${mfolder:0:4} == ${year} ]]
				then
					cd ${mfolder}
					for mfile in *
					do
						if [ -f ${mfile} ]
							then
								if [[ ${mfile:0:7} == ${mfolder} && ${mfile: -5} == ".pcap" ]]
									then
										echo ${telescope}', '${mfolder}', '${mfile}
										python /home/ella/active.py ${telescope} ${mfolder} ./${mfile}
								fi
						fi
					done
			fi
	fi
done
