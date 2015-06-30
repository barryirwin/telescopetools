#!/bin/bash
#call: ./plotHist.sh <filename> <graphname> <title> <top>
#<top> is an optional specification of how many IP's you'd like to see (ie top 10). If not specified then all will be shown

#plots a histogram of the file selected by the user

telescope=$1
month=$2
fname=$3
gname=$4
title=$5
numIPs=$6
let "numIPs--"
cd ${telescope}/${month:0:4}/${month}
pwd

if [[ numIPs != "" ]]
	then
	gnuplot <<- EOF
		set terminal postscript eps enhanced color font 'Helvetica,10'
		set output "${gname}"
		set xtic rotate by -45 scale 0
		plot "${fname}" every ::::${numIPs} u 2:xtic(1) t "${title}" w histograms
	EOF
else
	gnuplot <<- EOF
		set terminal postscript eps enhanced color font 'Helvetica,10'
		set output "${gname}"
		set xtic rotate by -45 scale 0
		plot "${fname}" u 2:xtic(1) t "${title}" w histograms
	EOF
fi
