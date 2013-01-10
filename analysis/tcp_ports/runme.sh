#!/bin/sh

#include the config
. ./config.inc


#only packets with SYN flag set/unset 
SYNSQL=" and  tcp.syn='t'"
NOSYNSQL=" and  tcp.syn='f' "

#Common SQL which Selects the top 40 TCP destination ports
CSQL1="select destport, count(tcp.id),count(tcp.id)/"
CSQL2=" as percentacetcp, count(tcp.id)/"
CSQL3=" as percetageall from tcp, packets"
CSQL4="group by destport
order by count desc
limit 40
"
#vars are pulled in from config
SQL3=" where dtstamp between date ${DSTART} and date ${DEND} "
SQL4=" and tcp.id=packets.id"



for SCOPE in ${SCOPES}
do
	SNAME=`echo ${SCOPE} | sed -e 's/telescope//' -e's/ru2010/19621ru/g'`
	#get the max count for the range we lookign at
	echo  Preparing  for ${SCOPE}:
	echo -n "   Counts: "
	TTCP=`echo "select count(tcp.id) from tcp, packets ${SQL3} ${SQL4};"| ${PSQL} -qt ${SCOPE}`
	echo -n " T "
	TALL=`echo "select count(packets.id) from packets ${SQL3};" | ${PSQL} -qt ${SCOPE}`
	echo A .. done
#	echo DEBUG: TTCP=${TTCP} TALL=${TALL}	
#	TTCP=1234
#	TALL=5678	
	echo -n "   Running Query .."
	echo "${CSQL1}(${TTCP}/100) ${CSQL2}(${TALL}/100) ${CSQL3}" \
	"${SQL3} ${SQL4} ${SYNSQL} ${CSQL4}" | $PSQL $SCOPE > ${SNAME}_SYN.csv
	echo TTCP=${TTCP} TALL=${TALL} > ${SNAME}_SYN.csv.stats
	echo SYN OK
	echo -n "   Running Query .."
	echo "${CSQL1}(${TTCP}/100) ${CSQL2}(${TALL}/100) ${CSQL3}" \
	"${SQL3} ${SQL4} ${NOSYNSQL} ${CSQL4}" |  $PSQL $SCOPE > ${SNAME}_NOSYN.csv
	echo TTCP=${TTCP} TALL=${TALL} > ${SNAME}_NOSYN.csv.stats
	echo NOSYN OK
	echo ${SCOPE} complete.
done

