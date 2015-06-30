#!/usr/bin/env python
#only works for files already split by month!
import dpkt, sys, time, math, subprocess

telescope=sys.argv[1]
month=sys.argv[2]
os.chdir(telescope
f=open(sys.argv[3])
dname=sys.argv[4]
pcap=dpkt.pcap.Reader(f)
#currentDay=str(01)
curDay=1
currentDay='0'+str(curDay)
dayCount=0
d=open(dname, 'w')
d.write("#Day\t\t#Count\n")
d.close()

def write(day, cnt):
	d=open(dname, 'a')
	d.write(day+'\t')
	d.write(str(cnt)+'\n')
	d.close()

for ts, buf in pcap:
	print currentDay
	pktTime=time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(ts))
	print pktTime
#	if len(currentDay)<2:
#		currentDay='0'+currentDay
#	if currentDay.startswith("0"):
#		curDay=int(currentDay[1:])
#		#print pktTime[9:(-9)]
#		pktT=int(pktTime[9:(-9)])
#	else:
#		curDay=int(currentDay)
#		#print curDay
#		pktT=int(pktTime[8:(-9)])
	pktT=pktTime[8:(-9)]
	if pktT==currentDay:
		dayCount=dayCount+1
	elif pktT > currentDay:
		day=pktTime[:8]+currentDay
		print day
		cnt=dayCount
		write(day, cnt)
		curDay=curDay+1
		currentDay='0'+str(curDay)
		currentDay=currentDay[-2:]
		dayCount=0
		if pktT==currentDay:
			dayCount=dayCount+1
	else:
		print 'error'

