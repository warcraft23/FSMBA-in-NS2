#!/usr/bin/perl

#---------- Default values ----------
$src = "49"; #source node
$dst = "0";  #dest node
$dist=20;    #distance between cars
$traffic=1;  #players
$rangenode=200; #range node
#------------------------------------
#Process command line args.
while ($_ = $ARGV[0], /^-/)
{
  shift;
  if (/^-h/)      { $usage; }
  elsif (/^-n1/)  { if ( $ARGV[0] ne '' ) {
		      $src = $ARGV[0];
                      shift; }}
  elsif (/^-n2/)  { if ( $ARGV[0] ne '' ) {
                      $dst = $ARGV[0];
		      shift; }}						
  elsif (/^-t/)  { if ( $ARGV[0] ne '' ) {
                      $traffic = $ARGV[0];
		      shift; }}	
  elsif (/^-r/)  { if ( $ARGV[0] ne '' ) {
                      $rangenode = $ARGV[0];
		      shift; }}				      
  else            { warn "$_ bad option\n"; &usage; }
}

#Now, make sure two filenames were specified
if ($ARGV[0] eq '') {
  warn "Need to specify two filenames\n";
  &usage;
}
if ($ARGV[1] eq '') {
  warn "Need to specify two filenames\n";
  &usage;
}

$rangefile = $ARGV[0];
$printfile = $ARGV[1];

#end command line processing
print "\nsrc node is:$src; dst node is:$dst \n";

print "extracting hops, slots and tot trasmission...\n";
#-----Number of hops for each pkt and tot trasmission -----

$outfile1 = "hops.$traffic";
$outfile2 = "slots.$traffic";
$tempfile = ".temp";
$tempfile2=".temp2";
$tempTotS=".tempTotS";
$tempTotR=".tempTotR";
$sendfile="tot_trasmission.$traffic";
$tmphop=".tmphop";
$printfile2=".pfile2";
$printfile3=".pfile3";
$temphowr=".temphowr";
$lost="lost";
	
####taking ending prints of dst node from print file and taking forward####
open(PFILE,$printfile) || die("Can't open $file input file for pfile\n");
open(PFILE2,">$printfile2") || die("Can't open $file input file for pfile 2\n");
open(TEMPFILE,">$tempfile") || die "error opening out file\n";

open(TMPHOP,">$tmphop") || die "error opening out file\n";
open(TEMPTOTS,">$tempTotS") || die "error opening tmp file\n";
open(TEMPTOTR,">$tempTotR") || die "error opening tmp file\n";
open(RFILE,">$temphowr") || die "error opening out file\n";

$line=<PFILE>;
while ($line) {
	$matchedn = ( $line =~ /^n\s$dst\s(\d+)\s(\d+)\s(\d+)/);
	$matchedfw = ( $line =~ /^f\s(\d+\.?\d*)\s(\d+)\s(\d+)/);

	$matcheds = ($line =~ /^s\s(\d+\.?\d*)\s$src\s(\d+)\s(\d+)/);
	$times=$1; $pkts=$3; $realpkts=$2; 
	#taking only the pkt generated from src, not trasmitted by it!
	if ( $matcheds && ($pkts == $realpkts)) { 
		print TMPHOP "$pkts\n";
		#for total trasmission...used after!!
		print TEMPTOTS "s $pkts $times\n"; 
	}
	
	$matchedrTot = ($line =~ /^r\s(\d+\.?\d*)\s(\d+)\s(\d+)/);
	$timerT=$1; $pktrT=$3; $noder=$2;

	if ( $matchedrTot ) {
		if ($noder == $dst) {
			print TEMPTOTR "r $pktrT $timerT\n";
		}
		#for how many pkt...used after!!
		print RFILE "$pktrT $noder\n"; 
	}
	
	if ($matchedn) {
		#$1=pkt $2=hops $3=slots
		print PFILE2 "$1 $2 $3\n"; 
	}
	
	if ( $matchedfw ) {
		#$1=Node $2=pkt
		print TEMPFILE "$2 $3\n"; 
	}
		
	$line=<PFILE>;
}
close TEMPFILE;
close PFILE;
close PFILE2;

close TMPHOP;
close TEMPTOTS;
close TEMPTOTR;
close RFILE;

#### sorting pkt received by pkt number####
open(PFILE2,$printfile2) || die("Can't open $file input file for pfile 2b\n");
open(PFILE3,">$printfile3") || die("Can't open $file input file for pfile 3\n");
@in=<PFILE2>;
@out = sort {key(1,$a) <=> key(1,$b)}@in;
print PFILE3 @out;
close PFILE2;
close PFILE3;

#### extracting hops and slot in outfile1 and 2####
open(LOST,">$lost") || die "error opening lost file\n";	
open(OUTFILE1,">$outfile1") || die "error opening out file\n";
open(OUTFILE2,">$outfile2") || die "error opening out file\n";
open(TMPHOP,"$tmphop") || die "error opening out file\n";
open(PFILE3,"$printfile3") || die("Can't open $file input file for pfile 3b\n");
$line = <TMPHOP>; #pkt sent from src
$linehop = <PFILE3>; #all pkt received by dest
while ($line) {
	$matcheds = ( $line =~ /^(\d+)/);
	$pkt=$1;

	while ($linehop) {
		$matchedhops = ( $linehop =~ /^(\d+)\s(\d+)\s(\d+)/);
		$p=$1;
		if ($matchedhops && ($p==$pkt)) {
			print OUTFILE1 "$2\n"; #print pkt hops
			print OUTFILE2 "$3\n"; #print pkt slots
			$linehop = <PFILE3>;
			last;
		}
		elsif ($p>$pkt) {
			print LOST "$pkt\n"; #print lost pkts
			last;
		} 
		$linehop = <PFILE3>;
	}
	$line = <TMPHOP>;
}
close OUTFILE1;
close OUTFILE2;
close TMPHOP;
close PFILE3;
close LOST;

####sorting tempfile#####
open(TEMPFILE,"$tempfile") || die "error opening out file\n";
open(TEMPFILE2,">$tempfile2") || die "error opening out file\n";
@in=<TEMPFILE>;
@out = sort {key(2,$a) <=> key(2,$b) || key(1,$a) <=> key(1,$b)}@in;
print TEMPFILE2 @out;
close TEMPFILE;
close TEMPFILE2;

####counting tot trasmission for all pkt#####

open(TEMPFILE2,"$tempfile2") || die "error opening out file\n";
open(TEMPFILE,">$tempfile") || die "error opening out file\n";
$count=0;
$pkt_prec=-1;
$line=<TEMPFILE2>;
while ($line) {
	$matched = ( $line =~ /^(\d+)\s(\d+)/);
	$pkt=$2;
	if ($pkt_prec==-1) {$pkt_prec=$pkt;}
	if ( $matched ) {
		if ($pkt_prec == $pkt) {
			$count=$count+1;
		}
		else {
			print TEMPFILE "$pkt_prec $count\n";
			$count=1;
			$pkt_prec=$pkt;		
		}
	}
	$line = <TEMPFILE2>;
}
close TEMPFILE2;
close TEMPFILE;

####taking only the packet generated by src node#####

open(TMPHOP,"$tmphop") || die "error opening out file\n";
open(TEMPFILE,"$tempfile") || die "error opening out file\n";
open(SENDFILE,">$sendfile") || die "error opening out file\n";
open(LOST,"$lost") || die "error opening lost read file\n";	
$linelost = <LOST>; #pkt lost
$line = <TMPHOP>; #pkt sent from src
while ($line) {
	$matcheds = ( $line =~ /^(\d+)/);
	$pkt=$1;
	$matchedlost = ( $linelost =~ /^(\d+)/);

	if ($matchedlost && ($pkt==$1)) {
		$linelost = <LOST>;
	}
	
	else {
		$linehop = <TEMPFILE>; #pkt N°of_trasmission
		while ($linehop) {
			$matchedhops = ( $linehop =~ /^(\d+)\s(\d+)/);
			$p=$1; $trans=$2;
			if ($matchedhops && ($p==$pkt)) {
				#print pkt trasmissions
				print SENDFILE "$trans\n"; 
				last;
			}
			elsif ($p>$pkt) {
				last;
			} 
			$linehop = <TEMPFILE>;
		}
		
	}
	$line = <TMPHOP>;	
}
close TMPHOP;
close TEMPFILE;
close SENDFILE;

print "extracting the time to cover the whole distance sender-->receiver...\n";
#----- Time to cover the whole distance sender-->receiver -----

$ttime="trasmissionTime.$traffic";
$tempTotRORD=".tempTotRORD";

####sorting pkts received for pkt number####
open(TEMPTOTR,"$tempTotR") || die "error opening out file\n";
open(TEMPTOTRORD,">$tempTotRORD") || die "error opening out file\n";
@in=<TEMPTOTR>;
@out = sort {key(2,$a) <=> key(2,$b) || key(3,$a) <=> key(3,$b)}@in;
print TEMPTOTRORD @out;
close TEMPTOTR;
close TEMPTOTRORD;

####computing time####
open(TTIME,">$ttime") || die "error opening out file\n";
open(TEMPTOTS,"$tempTotS") || die "error opening out file\n";
open(TEMPTOTRORD,"$tempTotRORD") || die "error opening out file\n";

$line=<TEMPTOTS>;
while ($line) {
	$matcheds = ($line =~ /^s\s(\d+)\s(\d+\.?\d*)/);
	$pkts=$1; $times=$2;
	if ( $matcheds ) {
		$liner = <TEMPTOTRORD>;
		while($liner){
			$matchedr = ($liner =~ /^r\s(\d+)\s(\d+\.?\d*)/);
			$pktr=$1; $timer=$2;			
			if ( $matchedr && $pkts==$pktr) {
				$timediff=($timer-$times)*1000;
				print TTIME "$timediff\n";
				last;
			}
			elsif($pktr>$pkts){
				last;
			}
			$liner = <TEMPTOTRORD>;
		}
	}
	$line = <TEMPTOTS>;
}
close TEMPTOTS;
close TTIME;
close TEMPTOTRORD;

print "extracting how many pkts generated by src are received by all nodes...\n";
#-----How many pkts generated by src are received by all nodes???-----

$tempord=".temp_ord";
$tempord2=".temp_ord2";
$hfile="howmanyrcv.$traffic";

system("sort $tmphop -n -k1 >$tempord");
system("sort $temphowr -n -k1 -k2 >$tempord2");

####taking one msg of the sender and counting how many times it has been received by other different nodes####
open(HFILE,">$hfile") || die "error opening out4 file\n";
open(SORD,"$tempord") || die "error opening out5 file\n";
open(RORD,"$tempord2") || die "error opening out6 file\n";
 
$lines=<SORD>;
$liner=<RORD>;
while ($lines) {
 	$matcheds = ($lines =~ /^(\d+)/);
 	$pkts=$1;
 	if ( $matcheds ) {
 		$noder_old=-1;
 		$count_nodes=0;
 		while ($liner) {
 			$matchedr = ($liner =~ /^(\d+)\s(\d+)/);
 			$pktr=$1; $noder=$2;
 			if ( $matchedr && ($pkts==$pktr) ) {
 				if ($noder != $noder_old){
 					$count_nodes=$count_nodes+1;
 					$noder_old=$noder;
 				}
 				$liner=<RORD>;
 			}
 			else {
				if ($pkts<$pktr) {
					last;
				}
				else {$liner=<RORD>;}
			}
 		}
 		print HFILE "$count_nodes\n";
 	
 	}
 	$lines=<SORD>;
 }

close SORD;
close RORD;
close HFILE;


print "extracting tot fmr and bmr for node $rangenode ...\n";

#-----tot fmr and bmr-----
$tempfmr=".tempfmr";
$tempbmr=".tempbmr";
$filefmr="fmr.$traffic.node$rangenode";
$filebmr="bmr.$traffic.node$rangenode";



open(RANGEFILE,"$rangefile") || die "error opening range file\n";
open(TEMPFMR,">$tempfmr") || die "error opening tempfmr0 file\n";
open(TEMPBMR,">$tempbmr") || die "error opening tempbmr0 file\n";
$line=<RANGEFILE>;
while ($line) {
	$matchedfmr = ( $line =~ /^fmr\s(\d+\.?\d*)\s(\d+\.?\d*)\s$rangenode\s(\d+)/);
	$matchedbmr = ( $line =~ /^bmr\s(\d+\.?\d*)\s(\d+\.?\d*)\s$rangenode\s(\d+)/);
	#used for fmr average... after
	if ( $matchedfmr) { 
		#$2=fmr $1=timestamp $3=pkt
		print TEMPFMR "$1 $2 $3\n"; 
	
	}
	#used for bmr average... after
	if ( $matchedbmr) {
		#$2=bmr $1=timestamp $3=pkt
		print TEMPBMR "$1 $2 $3\n"; 
	
	}
		
	$line=<RANGEFILE>;
}

close TEMPBMR;
close TEMPFMR;
close RANGEFILE;

open(TEMPFMR,"$tempfmr") || die "error opening tempfmr1 file\n";
open(TEMPBMR,"$tempbmr") || die "error opening tempbmr1 file\n";
open(FMR,">$filefmr") || die "error opening fmr file\n";
open(BMR,">$filebmr") || die "error opening bmr file\n";

####sorting files####
@in=<TEMPFMR>;
@out = sort {key(1,$a) <=> key(1,$b)}@in;
print FMR @out;

@in=<TEMPBMR>;
@out = sort {key(1,$a) <=> key(1,$b)}@in;
print BMR @out;

close TEMPFMR;
close TEMPBMR;
close FMR;
close BMR;

#used for sorting
 sub key {
 return (split (/ /, $_[1],5))[$_[0]-1]
 }

#print usage and quit
sub usage {
  printf STDERR "\n--- monitor.pl ---\n";
  printf STDERR "extract data for broadcast simulations\n";
  printf STDERR "usage: monitor.pl [flags] <rangefile> <tracefile> \n";
  printf STDERR "where:\n";
  printf STDERR "\t-n1 <n>              start node of the broacast (default $src)\n";
  printf STDERR "\t-n2 <n>              end node of the broadcast (default $dst)\n";
  printf STDERR "\t-t <n>               number of noises node (default $traffic)\n";
  printf STDERR "\t-r <n>               node used to compute ranges (default $rangenode)\n";	
exit(1);
}
