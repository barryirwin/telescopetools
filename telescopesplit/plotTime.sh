#!/bin/bash

fname=$1
gname=$2
title=$3


gnuplot <<- EOF
	set terminal postscript eps enhanced color font 'Helvetica,10'
	set output "${gname}"
	set xtic rotate by -45 scale 0
	plot "${fname}" u 2:xtic(1) t "${title}" w histograms
EOF

