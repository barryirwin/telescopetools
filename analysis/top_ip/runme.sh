#!/bin/sh
# process each telescope and extract the tp traffic sources by class

#pull in shared config
. ./config.inc
#-------------sql
#class A
SQLA=" srcip & INET '255.0.0.0' as srcbyA,"
SQLB=" srcip & INET '255.255.0.0' as srcbyB,"
SQLC=" srcip & INET '255.255.255.0' as srcbyC,"

BY="byA
byB
byC
"

PSQL="/usr/bin/psql -h spy.ict.ru.ac.za  -F , -A "

SQL1="count(id),count(id)"
SQL2=" as percentage, count(distinct(srcip)) as sources from packets"
SQL3=" where dtstamp between date ${DSTART} and date ${DEND} "
SQL4=" group by"
SQL5="order by count desc limit 20"
SQL6=" select count(id) from packets"


for SCOPE in ${SCOPES}
do

	SNAME=`echo ${SCOPE} | sed -e 's/telescope//' -e's/ru2010/19621ru/g'`
	#get the max count for the range we lookign at
	echo -n Preparing  for ${SCOPE}

	TCOUNT=`echo "select count(id) from packets ${SQL3};" | ${PSQL} -qt ${SCOPE}`
	echo .. done
	for b in ${BY}
	do
	case "$b" in
	byA)
		SQQ=${SQLA} ;;
	byB)
		SQQ=${SQLB} ;;
	byC)
		SQQ=${SQLC} ;;
	esac

	
	echo  -n "	Processing ${b}"

	echo "select ${SQQ} ${SQL1}/(${TCOUNT}/100.0) ${SQL2} ${SQL3} ${SQL4} \
	 src${b} ${SQL5}" \
	| $PSQL $SCOPE  > ${SNAME}_top20ip_${b}.csv
	echo "..ok"
	done
done

