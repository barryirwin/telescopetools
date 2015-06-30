#!/usr/bin/env python
import sys
directory = sys.argv[1]
fname = sys.argv[2]
dname = sys.argv[3]
print "running cntUnique.py..."

with open(fname) as f:
	cnt=sum(1 for _ in f)
print cnt

#provides top 10 source/destination IP addresses and a counter of how many times it was used

# counting unique destination IP's
f = open(dname,'r')
words = [x for y in [l.split() for l in f.readlines()] for x in y]
dArr= sorted([(w, words.count(w)) for w in set(words)], key = lambda x:x[1], reverse=True)[:]
#print 'unique dst IP: '
#print dArr
dfile=open(dname, "w")
dfile.write("#dstIP\t\t#count\t#percentage\n")
for dEl in dArr:
	if dEl[0].startswith("#"):
		continue
	dfile.write(dEl[0]+'\t')
	dfile.write(str(dEl[1])+'\t')
	per=str(float(dEl[1])/float(cnt)*100.0)
	dfile.write(per+'\n')
#[:per.index('.')+3]
dfile.close()

if(len(sys.argv)>4):
	sname = sys.argv[4]
	dpname = sys.argv[5]
	spname = sys.argv[6]
	

	# counting unique source IP's
	f = open(sname,'r')
	words = [x for y in [l.split() for l in f.readlines()] for x in y]
	dArr= sorted([(w, words.count(w)) for w in set(words)], key = lambda x:x[1], reverse=True)[:]
	#print 'top 10 src IP: '
	#print dArr
	dfile=open(sname, "w")
	dfile.write("#srcIP\t\t#count\t#percentage\n")
	for dEl in dArr:
		if dEl[0].startswith("#"):
			continue
		dfile.write(dEl[0]+'\t')
		dfile.write(str(dEl[1])+'\t')
		per=str(float(dEl[1])/float(cnt)*100.0)
		dfile.write(per+'\n')
	dfile.close()

	# counting unique source Ports if TCP/UDP
	if "TCP" in fname or "UDP" in fname:
		f = open(spname,'r')
		words = [x for y in [l.split() for l in f.readlines()] for x in y]
		dArr= sorted([(w, words.count(w)) for w in set(words)], key = lambda x:x[1], reverse=True)[:]
		dfile=open(spname, "w")
		dfile.write("#srcPrt\t#count\t#percentage\n")
		for dEl in dArr:
			if dEl[0].startswith("#"):
				continue
			dfile.write(dEl[0]+'\t')
			dfile.write(str(dEl[1])+'\t')
			per=str(float(dEl[1])/float(cnt)*100.0)
			dfile.write(per+'\n')
		dfile.close()

	# counting unique destination ports
	if "TCP" in fname or "UDP" in fname:
		f = open(dpname,'r')
		words = [x for y in [l.split() for l in f.readlines()] for x in y]
		dArr= sorted([(w, words.count(w)) for w in set(words)], key = lambda x:x[1], reverse=True)[:]
		dfile=open(dpname, "w")
		dfile.write("#dstPrt\t#count\t#percentage\n")
		for dEl in dArr:
			if dEl[0].startswith("#"):
				continue
			dfile.write(dEl[0]+'\t')
			dfile.write(str(dEl[1])+'\t')
			per=str(float(dEl[1])/float(cnt)*100.0)
			dfile.write(per+'\n')
		dfile.close()

