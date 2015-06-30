#!/bin/bash
#echo 'what file (year) would you like to split? ie. 2014.pcap.ddup' #must be the file name ie. 2014.pcap or 2014.pcap.ddup
#read filename
year=$2
telescope=$1
cd ${telescope}/${year}
place=`pwd`
pwd
dName='months'
for filename in *
do
	if [[ ${filename} == *".pcap" ]]
		then
			#echo 'Writing to: '${dName}
			first=`/usr/sbin/tcpdump -ttttnnr ${filename} | head -n 1`
			startmonth=${first:5:2}
			if [[ ${startmonth} == 0? ]]
				then
					startmonth=${startmonth:1:1}
			fi
			#echo ${startmonth}
			startyear=${first:0:4}
			#echo ${startyear}
			endmonth=$((startmonth+1))
			#echo ${endmonth}
			endyear=${startyear}
			#echo ${endyear}
			second=`/usr/sbin/tcpdump -ttttnnr ${filename} | tail -n 1`
			stopyear=${second:0:4}
			#echo ${stopyear}
			stopmonth=${second:5:2}
			if [[ ${stopmonth:0:1} == '0' ]]
				then
					stopmonth=${stopmonth:1:1}
			fi
			let "stopmonth++"
			if [[ ${stopmonth} == 13 ]]
				then
					stopmonth=1
					let "stopyear++"
			fi
			#echo ${stopmonth}
			echo 'splitting by month '$startyear-$startmonth' to '$stopyear-$stopmonth
			while
				[[ ${endyear} -lt ${stopyear} ]] || [[ ${startmonth} -lt ${stopmonth} ]]
			do
				if [[ ${endmonth} -lt 13 ]]
					then
						if [[ ${startmonth} -lt 9 ]]
							then
								sfilename=${startyear}-0${startmonth}
								if [ ! -d ${place}/${sfilename} ]
									then
										mkdir ${place}/${sfilename}
								fi
								sfilename=${sfilename}.pcap
								new=false
								while
									[[ ${new} == false ]]
								do
									if [ -f ${place}/${sfilename:0:7}/${sfilename} ]
										then
											if [[ ${sfilename} == ${startyear}-0${startmonth}.pcap ]]
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
								editcap -F libpcap -A ${startyear}'-0'${startmonth}'-01 00:00:00' -B ${endyear}'-0'${endmonth}'-01 00:00:00' ${filename} ${sfilename:0:7}/${sfilename}
								echo 'split '$startyear-$startmonth' to '$endyear-$endmonth
							elif [[ ${startmonth} == 9 ]]
								then
									sfilename=${startyear}-0${startmonth}
									if [ ! -d ${place}/${sfilename} ]
										then
											mkdir ${place}/${sfilename}
									fi
									sfilename=${sfilename}.pcap
									new=false
									while
										[[ ${new} == false ]]
									do
										if [ -f ${place}/${sfilename:0:7}/${sfilename} ]
											then
												if [[ ${sfilename} == ${startyear}-0${startmonth}.pcap ]]
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
									editcap -F libpcap -A ${startyear}'-0'${startmonth}'-01 00:00:00' -B ${endyear}'-'${endmonth}'-01 00:00:00' ${filename} ${sfilename:0:7}/${sfilename}
									echo 'split '$startyear-$startmonth' to '$endyear-$endmonth
							elif [[ ${startmonth} -gt 9 ]]
								then
									sfilename=${startyear}-${startmonth}
									if [ ! -d ${place}/${sfilename} ]
										then
											mkdir ${place}/${sfilename}
									fi
									sfilename=${sfilename}.pcap
									new=false
									while
										[[ ${new} == false ]]
									do
										if [ -f ${place}/${sfilename:0:7}/${sfilename} ]
											then
												if [[ ${sfilename} == ${startyear}-${startmonth}.pcap ]]
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
									editcap -F libpcap -A ${startyear}'-'${startmonth}'-01 00:00:00' -B ${endyear}'-'${endmonth}'-01 00:00:00' ${filename} ${sfilename:0:7}/${sfilename}
									echo 'split '$startyear-$startmonth' to '$endyear-$endmonth
						fi
						let "endmonth++"
						let "startmonth++"
				elif [[ ${endmonth} == 13 ]]
					then
						let "endyear++"
						let "endmonth=1"
						sfilename=${startyear}-${startmonth}
						if [ ! -d ${place}/${sfilename} ]
							then
								mkdir ${place}/${sfilename}
						fi
						sfilename=${sfilename}.pcap
						new=false
						while
							[[ ${new} == false ]]
						do
							if [ -f ${place}/${sfilename:0:7}/${sfilename} ]
								then
									if [[ ${sfilename} == ${startyear}-${startmonth}.pcap ]]
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
						editcap -F libpcap -A ${startyear}'-'${startmonth}'-01 00:00:00' -B ${endyear}'-'${endmonth}'-01 00:00:00' ${filename} ${sfilename:0:7}/${sfilename}
						echo 'split '$startyear-$startmonth' to '$endyear-$endmonth
						let "endmonth++"
						let "startmonth=1"
						let "startyear++"
				fi
			done
	fi
done


