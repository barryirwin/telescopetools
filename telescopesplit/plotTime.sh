#!/bin/bash

telescope=$1
month=$2
fname=$3
gname=$4
title=$5
cd ${telescope}/${month:0:4}/${month}
pwd

gnuplot <<- EOF
	set terminal postscript eps enhanced color font 'Helvetica,10'
	set output "${gname}"
	set xtic rotate by -45 scale 0
	plot "${fname}" u 2:xtic(1) t "${title}" w histograms
EOF

