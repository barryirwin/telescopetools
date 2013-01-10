#!/bin/sh

#include Global config
. ./config.inc

CSVFILES="_top20ip_byA.csv
_top20ip_byB.csv
_top20ip_byC.csv
"

SQL1=" select date_trunc('day', dtstamp) as interval_byday, count(distinct srcip) as sources, count(distinct destip) as dests,count(packets.id) from packets where  "

SQL2="group by interval_byday order by interval_byday; "

mask=32

for SCOPE in ${SCOPES}
do
        SNAME=`echo ${SCOPE} | sed -e 's/telescope//'  -e's/ru2010/19621ru/g'`
         echo Starting Top Traffic sources  for $SCOPE

	for f in  ${CSVFILES}
	do
		cat ${SNAME}${f}  | grep -vE "des|row|src|count" | awk -F, '{print $1}' > /tmp/topip_${SNAME}.$$
	class=` echo ${f} | sed -e 's/_top20ip_by//g' -e 's/.csv//g'`
	echo  -n Class grouping is  $class

	case "$class" in
	A)
	  mask=8 
	  ;;
	B)
	  mask=16 
	  ;;
	C)
	  mask=24
	  ;;
	esac

	echo " using a cluster mask of  /$mask bits. "
	for SRCIP in `cat /tmp/topip_${SNAME}.$$`
		do
		SRCIPx="${SRCIP}/${mask}"
		echo Processing  $SRCIP with mask of ${mask}
		echo  ${SQL1} "srcip << inet '${SRCIPx}'" ${SQL2} \
		 |  $PSQL ${SCOPE} |\
		sed -e 's/interval_byday/#interval_byday/' -e 's/(/#(/' \
 		>  ${SNAME}_topip_${SRCIP}_by${mask}_byday.csv 

	done
	rm /tmp/topip_${SNAME}.$$
	#CSVFILE LOOP
	done
# SCOPE loop
done
  



## CLEANUP


