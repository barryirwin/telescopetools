#!/bin/sh

# takes in topN lists of ports and produces CSV output by day
#pull in global config

. ./config.inc

CSVFILES="_SYN.csv
_NOSYN.csv
"

CSQL1=" select date_trunc('day', dtstamp) as interval_byday, count(distinct srcip) as sources, count(packets.id) from packets, tcp where packets.id=tcp.id and "
CSQL2=" group by interval_byday order by interval_byday; "
DSQL=" and  dtstamp between date ${DSTART} and date ${DEND} "

for SCOPE in ${SCOPES}
do
        SNAME=`echo ${SCOPE} | sed -e 's/telescope//'`
        echo Starting Top TCP ports for $SCOPE

	for syn in ${CSVFILES}
	do
	STYPE=`echo ${syn} | sed -e s/_// -e s/.csv//g`
	cat ${SNAME}${syn} | grep -vE "des|row" | awk -F, '{print $1}' > /tmp/toptcpports.$$
	#DEBUG:
	#cat /tmp/toptcpports.$$
		for port in `cat /tmp/toptcpports.$$`
		do
		echo -n "  Processing  $port (${STYPE})" 
		echo  ${CSQL1}  tcp.destport=${port} ${DSQL} ${CSQL2}  | $PSQL ${SCOPE} | sed -e 's/interval_byday/#interval_byday/'  -e 's/(/#(/'  > ${SNAME}_tcp_${port}_${STYPE}_src_byday.csv 
		echo "  ok."
		done

	## CLEANUP
	rm /tmp/toptcpports.$$
	done

done

