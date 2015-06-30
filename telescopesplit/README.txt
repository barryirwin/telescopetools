
Splitting up files:
1) ./splitYear.sh <directoryname> (ie. /mnt/datapool/telescope/data/146scope)
	
2) ./mergeYears.sh <telescopename> (ie. 146scope) <year> (ie. 2014) <-- shouldn't need, rather use mergeMonths
3) ./splitMonths.sh <telescopename> (ie. 146scope) <year> (ie. 2014)
4) ./mergeMonths.sh <telescopename> (ie. 146scope) <foldername> (ie. 2014-11)  
5) ./makeReport.sh <telescopename> (ie. 146scope) <foldername> (ie. 2014-11)
6) ./genCheckSum.sh <telescopename> (ie. 146scope) <year> (ie. 2014)
7) ./checkCheckSum.sh <telescopename> (ie. 146scope) <year> (ie. 2014)

Generating graphs & analysing data:
1) ./runActive.sh <telescopename> (ie. 146scope) <yearfoldername> (ie. 2014) 
	Must be run on a year folder
	Runs active.py for all month files in the specified year
2) ./active.py <telescopename> (ie. 146scope) <monthfilename> (ie. 2014-11.pcap) 
	Must be run on a month/year file
	File must end in .pcap
	If it doesn't run this in command line (newFileName must end in .pcap):
		editcap -F libpcap -T ether <originalFileName> <newFileName>
	Required in order to run scripts below
3) ./splitColumns.sh <filedirectory> (ie. /146scope/2013/2013-01/TCPactive.txt)
	Must be run on the output from active.py
	Calls ./cntUnique.py with arguments automatically
	splitColumns.sh and cntUnique.py are Required in order to run scripts below
4) ./splitColumnsExclPort.sh <telescope> (ie. 146scope) <monthfoldername> (ie. 2015-01) <filename> (ie. TCPactive.txt) <port> (ie. 445)
	Alternative to splitColumns.sh for if you wish to exclude a specified port
	Calls ./cntUnique.py with arguments automatically
5) ./plotHist.sh <telescope> (ie. 146scope) <monthfoldername> (ie. 2015-01) <filename> (ie. TCPactivesrcUniq.txt) <graphname> (ie. TCPactiveSrcGraph.eps) <graphtitle> (ie. "Top 10 source IP's") <numberOfIPsIncludedInGraph> (ie. 10)
	Must be run on the output from cntUnique.py
6) ./plotMonRange.sh <telescope> (ie. 146scope) <monthfoldername> (ie. 2015-01) <filename> (ie. TCPactivedstUniq.txt) <graphname> (ie. monRangePlotPass.eps) <graphtitle> (ie. "monitored destination range")
	Must be run on the output from cntUnique.py and only on the destination IP addresses
7) ./percenOfTop.sh <telescope> (ie. 146scope) <monthfoldername> (ie. 2015-01) <filename> (ie. TCPactivesrcUniq.txt) <numberOfIPsIncludedInPercentage> (ie. 20)
	Must be run on the output from cntUnique.py
	Does not write to a file, just spits out the percentage into standard output
8) ./plotTime.py <telescope> (ie. 146scope) <monthfoldername> (ie. 2015-01) <filename> (ie. 2014-11.pcap) <destinationfilename> (ie.times.txt)
	Must be run on a month/year file. File must end in .pcap
9) ./plotTime.sh <telescope> (ie. 146scope) <monthfoldername> (ie. 2015-01) <filename> (destination file name from plotTime.py) <graphfilename> (ie.timesGraph.eps) <graphtitle> (ie. "packets per day")
	Must be run on the output from plotTime.py
10) ./anon.sh <filename> (ie.2014-11.pcap) <destinationfilename> (ie. 2014-11.anon.pcap)
	Must be run on a month/year file. File must end in .pcap
	If it doesn't work (ie. not a .pcap file) run this in command line (newFileName must end in .pcap):
		editcap -F libpcap -T ether <originalFileName> <newFileName>
