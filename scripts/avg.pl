#!/usr/bin/perl


#------------------------------------------ Default values-------------------------------------------------------------
$index=0;
$title="";
$field=2;
#--------------------------------------------------------------------------------------------------------------------------

while ($_ = $ARGV[0])
{ 
  #shift;
  if (/^-h/)      { &usage; }
  elsif (/^-f/)  { if ( $ARGV[1] ne '' ) {
                      $field = $ARGV[1];
		      shift; shift; }}		
  
  else 		 { if ( $ARGV[0] ne '' ) {
		      $arrayfile[$index]=$ARGV[0]; $index=$index+1; 
		      shift; }}
 
}

#print "Title: $title\n";

$arrayfile[0] =~ /(.*)\.(\d+)\.?.*/; 
$yl=$1;


#compute average
$avgfile="avg.$yl";
for ($i=0;$i<$index;$i++) {

	open(INFILE,"$arrayfile[$i]") || die "error opening in file\n";
	if ($i==0) {	open(OUTFILE,">$avgfile") || die "error opening out file\n";}
	else {	open(OUTFILE,">>$avgfile") || die "error opening out file\n";}
	$sum=0;
	$count=0;
	$line=<INFILE>;
	
	while ($line) {
		#59.8702 280 
		if ($field==2) {
			$matcheds = ($line =~ /^(\d+\.?\d*)\s(\d+)/);
			$field1=$1; $field2=$2;
		}
		elsif ($field==1) {
			$matcheds = ($line =~ /^(\d+)/);
			$field2=$1;
		}
		if ( $matcheds ) {
			$count=$count+1;
			$sum=$sum+$field2;
		}	
		$line = <INFILE>;
	}
	$avg=$sum/$count;
	$arrayfile[$i] =~ /.*\.(\d+).*/;
	#$tr=$1;
	#print "$arrayfile[$i] traffic: $\ \n";
	print OUTFILE "$1 $avg\n"; 
	close INFILE;
	close OUTFILE;
}

#create gnuplot file

$plo="plotta.out";
open(PLOTFILE,">$plo") || die "error opening plot file\n";

#Graphic for hops

print PLOTFILE "set xlabel \"traffic\"\n";

#$lo=$2;
if ($yl=~ /.*[t|T]ime.*/) {$yl="$yl(ms)"}
print PLOTFILE "set ylabel \"$yl\"\n";
if (!$title){$title="$yl average by traffic";}
print PLOTFILE "set title \"$title\"\n";
print PLOTFILE "set output \"_avg_$yl.eps\"\n";
print PLOTFILE "set terminal postscript eps\n";
print PLOTFILE "set style fill solid 0.50\n";
print PLOTFILE "set boxwidth 1\n";
#$arrayfile[@arrayfile-1] =~ /(.*)\.(\d*)/;
#$hi=$2;
print PLOTFILE "set xrange [0:]\n";
print PLOTFILE "set yrange [0:]\n";
print PLOTFILE "plot \"$avgfile\" with boxes\n";
close PLOTFILE;
system ("gnuplot $plo");


####### print usage and quit
sub usage {
  printf STDERR "\n--- avg.pl ---\n";
  printf STDERR "creates avg graphic for broadcast simulation\n";
  printf STDERR "usage: avg.pl -f <fields> [FILE] [FILE...]\n";
  exit(1);
}

