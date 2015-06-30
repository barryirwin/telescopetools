#!/bin/bash
cd /home/ella/Desktop/data/dataset
#echo 'type year to generate checksums for ie. 2014'
#read year
telescope=$1
year=$2
place=`pwd`
cd ${telescope}/${year}
for folder in *
do
	if [[ ${folder} != *.pcap ]] && [[ ${folder} != checksum* ]] && [[ ${folder} != unmerged ]] && [[ ${folder} != *.pcap* ]]
		then
			cd ${folder}
			pwd
			found=false
			for file in *
			do
				if [[ ${file} == *.pcap.ddup ]] #change this if you cange the output format for mergemonths
					then
						found=true
						echo 'generate checksum for '${file}'? (y/n)'
						read gen
						if [[ ${gen} == y ]]
							then
								md5sum ${file} >> ${place}/${telescope}/${year}/checksum.md5
								sha1sum ${file} >> ${place}/${telescope}/${year}/checksum.sha1
								sha256sum ${file} >> ${place}/${telescope}/${year}/checksum.sha256
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
						if [[ ${file} == *.pcap ]]  #checks for .pcap files if there are no .pcap.ddup files
							then
								found=true
								echo 'generate checksum for '${file}'? (y/n)'
								read gen
								if [[ ${gen} == y ]]
									then
										md5sum ${file} >> ${place}/${telescope}/${year}/checksum.md5
										sha1sum ${file} >> ${place}/${telescope}/${year}/checksum.sha1
										sha256sum ${file} >> ${place}/${telescope}/${year}/checksum.sha256
								elif [[ ${gen} != n ]]
									then
										echo 'invalid input. select y or n'
								fi
						fi
					done
			fi
			cd ..
	fi
done
