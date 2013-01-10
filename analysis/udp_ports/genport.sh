#!/bin/sh

# takes in topN lists of ports and produces CSV output by day
#pull in global config

. ./config.inc


CSQL1=" select date_trunc('day', dtstamp) as interval_byday, count(distinct srcip) as sources, count(packets.id) from packets, udp where packets.id=udp.id and "
CSQL2="group by interval_byday order by interval_byday; "
DSQL=" and dtstamp between date ${DSTART} and date ${DEND} "

for SCOPE in ${SCOPES}
do
        SNAME=`echo ${SCOPE} | sed -e 's/telescope//'`
        echo Starting Top UDP  ports for $SCOPE

	cat ${SNAME}_topudp.csv  | grep -vE "des|row" | awk -F, '{print $1}' > /tmp/topudpports.$$
	#cat /tmp/topudpports.$$
      	
	for port in `cat /tmp/topudpports.$$`
	do
	echo -n "  Processing  $port " 
	#echo DEBUG: 
	#echo --------------------------------------------------
	#echo  ${CSQL1}  udp.destport=${port} ${DSQL} ${CSQL2}
	#echo --------------------------------------------------
	echo  ${CSQL1}  udp.destport=${port} ${DSQL} ${CSQL2} \
	| $PSQL ${SCOPE} | sed -e 's/interval_byday/#interval_byday/' -e 's/(/#(/'  > ${SNAME}_udp_${port}_src_byday.csv 
	echo "  ok."
	done
	## CLEANUP
 	rm /tmp/topudpports.$$

done

