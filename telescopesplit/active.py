#!/usr/bin/env python

#finds the IP addresses of all tcp packets with either the syn/ack flags set (not both) and all the icmp packets that are not echo replies
#writes all the source IP addresses to srcIP.txt and the destination IP addresses to dstIP.txt


import dpkt
import math
from dpkt.ip import IP
from dpkt.icmp import ICMP
import socket    
import sys   
import datetime 
import os

print os.getcwd()
telescope=sys.argv[1]
month=sys.argv[2]
year=month[:4]

f=file(sys.argv[3])
#print '#####'+sys.argv[3]
pcap=dpkt.pcap.Reader(f)
tactvfile=open("TCPactive.txt", "w")   #insert if you want to empty the file before running this method
tactvfile.write('#dstIP\t\t#srcIP\t\t#dstPort\t#srcPort\n')
tactvfile.close()
tpassfile=open("TCPpassive.txt", "w")   #insert if you want to empty the file before running this method
tpassfile.write('#dstIP\t\t#srcIP\t\t#dstPort\t#srcPort\n')
tpassfile.close()
iactvfile=open("ICMPactive.txt", "w")   #insert if you want to empty the file before running this method
iactvfile.write('#dstIP\t\t#srcIP\t\t#type:code\n')
iactvfile.close()
ipassfile=open("ICMPpassive.txt", "w")   #insert if you want to empty the file before running this method
ipassfile.write('#dstIP\t\t#srcIP\t\t#type:code\n')
ipassfile.close()
ufile=open("UDPtraffic.txt", "w")   #insert if you want to empty the file before running this method
ufile.write('#dstIP\t\t#srcIP\t\t#dstPort\t#srcPort\n')
ufile.close()
gfile=open("garbageTraffic.txt", "w")
gfile.close()

def writeTCPActive():
	#print 'destination: '+socket.inet_ntoa(ip.dst)
	#print 'source: '+socket.inet_ntoa(ip.src)
	tactvfile=open("TCPactive.txt", "a")
	tactvfile.write(socket.inet_ntoa(ip.dst)+'\t')
	tactvfile.write(socket.inet_ntoa(ip.src)+'\t')
	try: tactvfile.write(str(ip.data.dport)+'\t')
	except: tactvfile.write('dport err\t')
	try: tactvfile.write(str(ip.data.sport)+'\n')
	except: tactvfile.write('sport err\t')
	tactvfile.close()
def writeTCPPassive():
	#print 'destination: '+socket.inet_ntoa(ip.dst)
	#print 'source: '+socket.inet_ntoa(ip.src)
	tpassfile=open("TCPpassive.txt", "a")
	tpassfile.write(socket.inet_ntoa(ip.dst)+'\t')
	tpassfile.write(socket.inet_ntoa(ip.src)+'\t')
	try: tpassfile.write(str(ip.data.dport)+'\t')
	except: tpassfile.write('dport err\t')
	try: tpassfile.write(str(ip.data.sport)+'\n')
	except: tpassfile.write('sport err\t')
	tpassfile.close()
def writeICMPActive():
	#print 'destination: '+socket.inet_ntoa(ip.dst)
	#print 'source: '+socket.inet_ntoa(ip.src)
	iactvfile=open("ICMPactive.txt", "a")
	iactvfile.write(socket.inet_ntoa(ip.dst)+'\t')
	iactvfile.write(socket.inet_ntoa(ip.src)+'\t')
	iactvfile.write(str(icmp.type)+':'+str(icmp.code)+'\n')
	iactvfile.close()
def writeICMPPassive():
	#print 'destination: '+socket.inet_ntoa(ip.dst)
	#print 'source: '+socket.inet_ntoa(ip.src)
	ipassfile=open("ICMPpassive.txt", "a")
	ipassfile.write(socket.inet_ntoa(ip.dst)+'\t')
	ipassfile.write(socket.inet_ntoa(ip.src)+'\t')
	ipassfile.write(str(icmp.type)+':'+str(icmp.code)+'\n')
	ipassfile.close()
def writeUDP():
	#print 'destination: '+socket.inet_ntoa(ip.dst)
	#print 'source: '+socket.inet_ntoa(ip.src)
	ufile=open("UDPtraffic.txt", "a")
	ufile.write(socket.inet_ntoa(ip.dst)+'\t')
	ufile.write(socket.inet_ntoa(ip.src)+'\t')
	try: ufile.write(str(ip.data.dport)+'\t')
	except: ufile.write('dport err\t')
	try: ufile.write(str(ip.data.sport)+'\n')
	except: ufile.write('sport err\t')
	ufile.close()
i=0
for ts, buf in pcap:
	print i
	try: eth = dpkt.ethernet.Ethernet(buf)
	except: continue
	if eth.type != 2048: continue
	try: ip = eth.data
	except: continue
	if ip.p == dpkt.ip.IP_PROTO_TCP:
		#print 'TCP Packet'
		tcp = ip.data
		try:
			none_flag = tcp.flags==0
			syn_flag = ( tcp.flags & dpkt.tcp.TH_SYN )!=0
			ack_flag = ( tcp.flags & dpkt.tcp.TH_ACK ) !=0
			fin_flag = ( tcp.flags & dpkt.tcp.TH_FIN )!=0
			psh_flag = ( tcp.flags & dpkt.tcp.TH_PUSH )!=0
			urg_flag = ( tcp.flags & dpkt.tcp.TH_URG )!=0
			rst_flag = ( tcp.flags & dpkt.tcp.TH_RST )!=0
		except: continue
		if none_flag:
			#print 'Active'
			writeTCPActive() 
		elif rst_flag and not ( fin_flag or psh_flag or urg_flag or syn_flag or ack_flag ):
			#print 'Passive'
			writeTCPPassive()
		elif ( syn_flag and ack_flag ) and not ( fin_flag or psh_flag or urg_flag ):
			#print 'Passive'
			writeTCPPassive()
		elif ( syn_flag or ack_flag ) and not ( fin_flag or psh_flag or urg_flag ):
			#print 'Active'
			writeTCPActive()
		elif syn_flag or ack_flag:
			gfile=open("garbageTraffic.txt", "a")
			gfile.write("TCP Packet:\t")
			gfile.write("DstIP: "+socket.inet_ntoa(ip.dst)+'\t')
			gfile.write("SrcIP: "+socket.inet_ntoa(ip.src)+'\t')
			gfile.write("DstPort: "+str(tcp.dport)+'\t')
			gfile.write("SrcPort: "+str(tcp.sport)+'\t')
			gfile.write("flags set:")
			if syn_flag:
				gfile.write(' SYN')
			if ack_flag:
				gfile.write(' ACK')
			if fin_flag:
				gfile.write(' FIN')
			if psh_flag:
				gfile.write(' PSH')
			if urg_flag:
				gfile.write(' URG')
			gfile.write('\n')
			gfile.close()
		elif urg_flag or psh_flag or fin_flag:
			#print 'Active'
			writeTCPActive()
		else:
			gfile=open("garbageTraffic.txt", "a")
			gfile.write("TCP Packet:\t")
			gfile.write("DstIP: "+socket.inet_ntoa(ip.dst)+'\t')
			gfile.write("SrcIP: "+socket.inet_ntoa(ip.src)+'\t')
			gfile.write("DstPort: "+str(tcp.dport)+'\t')
			gfile.write("SrcPort: "+str(tcp.sport)+'\t')
			gfile.write("flags set:")
			if syn_flag:
				gfile.write(' SYN')
			if ack_flag:
				gfile.write(' ACK')
			if fin_flag:
				gfile.write(' FIN')
			if psh_flag:
				gfile.write(' PSH')
			if urg_flag:
				gfile.write(' URG')
			gfile.write('\n')
			gfile.close()
	if ip.p==dpkt.ip.IP_PROTO_ICMP:
		#print 'ICMP Packet'
		#print ip.data.type
		icmp=ip.data
		#print icmp.type
		if ( icmp.type==0 and icmp.code==0 ) or icmp.type==3 or ( icmp.type==4 and icmp.code==0 ) or icmp.type==11 or icmp.type==12 or ( icmp.type==13 and icmp.code==0 ) or ( icmp.type==16 and icmp.code==0 ) or ( icmp.type==0 and icmp.code==0 ) or icmp.type==31 or icmp.type==34 or icmp.type==36:
			#print 'Passive'
			writeICMPPassive()
		elif icmp.type==8 or icmp.type==13 or icmp.type==16 or icmp.type==18 or icmp.type==30 or icmp.type==33 or icmp.type==35:
			#print 'Active'
			writeICMPActive()
		else:
			gfile=open("garbageTraffic.txt", "a")
			gfile.write("ICMP Packet:\t")
			gfile.write("DstIP: "+socket.inet_ntoa(ip.dst)+'\t')
			gfile.write("SrcIP: "+socket.inet_ntoa(ip.src)+'\t')
			gfile.write("Type: "+str(icmp.type)+'\t')
			gfile.write("Code: "+str(icmp.code)+'\t')
			gfile.write('\n')
			gfile.close()
	if ip.p==dpkt.ip.IP_PROTO_UDP:
		try: udp=ip.data
		except: print 'issue with udp=ip.data'
		writeUDP()
	i=i+1

