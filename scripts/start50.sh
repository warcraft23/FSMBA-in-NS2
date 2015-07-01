#!/bin/sh
	#parameters to change
	range="range.tr"
	trace="trace.tr"
	src_node=399;
	dst_node=15;
	numNOISES=50;
	rangenode=200;

	rm -f $trace $range
	m=`expr $src_node - $dst_node + 5`
	echo "starting simulation ..."
	ns ./broadcast.tcl $numNOISES $src_node
	echo "extracting data ..."
	/usr/bin/perl ./monitor.pl -n1 $src_node  -n2 $dst_node -t $numNOISES -r $rangenode $range $trace

	echo "plotting data ..."
	plo="plotta.out";
	#Graphic for hops
	echo "set xlabel \"pkts\"">$plo
	echo "set ylabel \"hops\"">>$plo
	echo "set output \"_hops_t$numNOISES.eps\"">>$plo
	echo "set terminal postscript eps">>$plo
	echo "set xrange [0:]">>$plo
	echo "set yrange [0:]">>$plo
	echo "plot \"hops.$numNOISES\" with lines">>$plo
	gnuplot plotta.out	

	#Graphic for slots	
	echo  "set xlabel \"pkts\"">$plo
	echo  "set ylabel \"slots\"">>$plo
	echo  "set output \"_slots_t$numNOISES.eps\"">>$plo
	echo  "set terminal postscript eps">>$plo
	echo "set xrange [0:]">>$plo
	echo "set yrange [0:]">>$plo
	echo  "plot \"slots.$numNOISES\" with lines">>$plo	 
	gnuplot plotta.out	

	#Graphic for total trasmissions x pkt
	echo  "set xlabel \"pkts\"">$plo
	echo  "set ylabel \"trasmissions\"">>$plo
	echo  "set output \"_tot_trasmission_t$numNOISES.eps\"">>$plo
	echo  "set terminal postscript eps">>$plo
	echo "set xrange [0:]">>$plo
	echo "set yrange [0:]">>$plo
	echo  "plot \"tot_trasmission.$numNOISES\" with lines">>$plo
	gnuplot plotta.out	

	#Graphic for trasmission time
	echo  "set xlabel \"pkts\"">$plo
	echo  "set ylabel \"time(ms)\"">>$plo
	echo  "set output \"_trasmissionTime_t$numNOISES.eps\"">>$plo
	echo  "set terminal postscript eps">>$plo
	echo "set xrange [0:]">>$plo
	#echo "set yrange [0:]\n">>$plo
	echo  "plot \"trasmissionTime.$numNOISES\" with lines">>$plo
	gnuplot plotta.out	

	#Graphic for number of receive for each pkt
	echo  "set xlabel \"pkts\"">$plo
	echo  "set ylabel \"receives\"">>$plo
	echo  "set output \"_howmanyrcv_t$numNOISES.eps\"">>$plo
	echo  "set terminal postscript eps">>$plo
	#echo "set xrange [0:]">>$plo	
	echo "set yrange [:$m]">>$plo
	echo  "plot \"howmanyrcv.$numNOISES\" with lines">>$plo
	gnuplot plotta.out	
	
	#Graphic for fmr values
	echo  "set xlabel \"time(ms)\"">$plo
	echo  "set ylabel \"fmr\"">>$plo
	echo  "set output \"_fmr_t$numNOISES.eps\"">>$plo
	echo  "set terminal postscript eps">>$plo
	#echo "set xrange [0:]">>$plo	
	echo "set yrange [0:300]">>$plo
	echo  "plot \"fmr.$numNOISES.node$rangenode\" with lines">>$plo
	gnuplot plotta.out	

	#Graphic for bmr values
	echo  "set xlabel \"time(ms)\"">$plo
	echo  "set ylabel \"bmr\"">>$plo
	echo  "set output \"_bmr_t$numNOISES.eps\"">>$plo
	echo  "set terminal postscript eps">>$plo
	#echo "set xrange [0:]">>$plo	
	echo "set yrange [0:300]">>$plo
	echo  "plot \"bmr.$numNOISES.node$rangenode\" with lines">>$plo
	gnuplot plotta.out

	echo "ALL DONE"
