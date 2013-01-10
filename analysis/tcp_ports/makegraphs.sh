#!/bin/sh
# builds graphs of a given type

# ger global configs

. ./config.inc

# local config variables
TEMPLATE='template.plt'
GNUPLOT='/usr/bin/gnuplot'
#REPLACE=`echo s/XXFILEXX/${f}/g`
#REPLACE="'${XREPLACE}'"
#udp_6268_src_byday.csv
#PORT=` echo ${f} |sed -e 's/tcp_//' -e 's/_SYN_src_byday.csv//'`
#topip_196.21.142.0_by24_byday.csv
# Strip off quotes
DSTART2=`echo ${DSTART} | sed -e s/\'//g`
DEND2=`echo ${DEND} | sed -e s/\'//g`

for f in `ls *_byday.csv`
do
  echo -n  Generating graph for ${f}

        REPLACE="s/XXFILEXX/${f}/g"
        FILE=`echo $f | sed -e 's/csv/png/'`
        REPLACEFILE="s/XXFILEOUTXX/${FILE}/"
        TITLE=`echo $f | sed -e 's/topip_//' -e 's/_byday.csv//' -e 's/_by24//' -e 's/_by16//' -e 's/_by8//'`
        TITLE2=`echo $f | sed  -e 's/_byday.csv//' -e 's/topip_.*_by//'`
        REPLACETITLE="s/XXTITLEXX/${TITLE}\/${TITLE2}/"
        RDSTART="s/XXDSTARTXX/${DSTART2}/g"
        RDEND="s/XXDENDXX/${DEND2}/g"

        #now mod the template on the fly and run
        cat ${TEMPLATE} | \
        sed -e $REPLACE -e $REPLACEFILE -e $REPLACETITLE \
            -e $RDSTART -e $RDEND \
         | ${GNUPLOT}

  echo "..  done"
done

