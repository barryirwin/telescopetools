#!/bin/sh
# pulls up a list of the top 40 UDP ports for each telescope

#include the config
. ./config.inc



#Common SQL which Selects the top 40 TCP destination ports
CSQL1="select destport, count(udp.id),count(udp.id)/"
CSQL2=" as percentudp, count(udp.id)/"
CSQL3=" as percetall from udp, packets"
CSQL4="group by destport
order by count desc
limit 40
"
#vars are pulled in from config
SQL3=" where dtstamp between date ${DSTART} and date ${DEND} "
SQL4=" and udp.id=packets.id"



for SCOPE in ${SCOPES}
do
	SNAME=`echo ${SCOPE} | sed -e 's/telescope//' -e's/ru2010/19621ru/g'`
	#get the max count for the range we lookign at
	echo  Preparing  for ${SCOPE}:
	echo -n "   Counts: "
	TUDP=`echo "select count(udp.id) from udp, packets ${SQL3} ${SQL4};"| ${PSQL} -qt ${SCOPE}`
	echo -n " U "
	TALL=`echo "select count(packets.id) from packets ${SQL3};" | ${PSQL} -qt ${SCOPE}`
	echo A .. done
	echo DEBUG: TUDP=${TUDP} TALL=${TALL}	
#	TUDP=1234
#	TALL=5678	
	echo -n "   Running Query .."
	echo "${CSQL1}(${TUDP}/100.0) ${CSQL2}(${TALL}/100.0) ${CSQL3}" \
	"${SQL3} ${SQL4}  ${CSQL4}" | $PSQL $SCOPE > ${SNAME}_topudp.csv
	echo TUDP=${TUDP} TALL=${TALL} > ${SNAME}_topudp.csv.stats
	echo OK
	echo ${SCOPE} complete.
done

