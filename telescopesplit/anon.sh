#!/bin/bash

fname=$1
dname=$2

traceanon -d -p 196.0.0.0/24 pcapfile:${fname} pcapfile:${dname}
#tshark -r ${dname} -T fields -e ip.dst -e ip.src
