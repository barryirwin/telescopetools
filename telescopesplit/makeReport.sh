#!/bin/bash
cd /home/ella/Desktop/data/dataset
#echo 'type month to generate reports for ie. 2014-11'
#read folder
telescope=$1
folder=$2
cd ${telescope}/${folder:0:4}
cd ${folder}
if [[ ! -d reports ]]
	then
		mkdir reports
fi
found=false
for file in *
do
	if [[ ${file} == *.pcap.ddup ]]  #change this if you cange the output format for mergemonths
		then
			echo 'generate report for '${file}'? (y/n)'
			read gen
			if [[ ${gen} == y ]]
				then
					found=true
					tracereport pcap:${file}
					for rep in *
					do
						if [[ ${rep} == *.rpt ]]
							then
								mv ${rep} reports/${rep%.*}'_'${file}'.'${rep#*.}
						fi
					done
			elif [[ ${gen} != n ]]
				then
					echo 'invalid input. select y or n'
			fi
	fi
done
if [[ ${found} == false ]]
	then
		for file in *
		do
			if [[ ${file} == *.pcap ]]  #checks for .pcap files if there are no .pcap.ddup
				then
					echo 'generate report for '${file}'? (y/n)'
					read gen
					if [[ ${gen} == y ]]
						then
							found=true
							tracereport  pcap:${file}
							for rep in *
							do
								if [[ ${rep} == *.rpt ]]
									then
										mv ${rep} reports/${rep%.*}'_'${file}'.'${rep#*.}
								fi
							done
					elif [[ ${gen} != n ]]
						then
							echo 'invalid input. select y or n'
					fi
			fi
		done
fi
