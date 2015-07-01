start.sh
- It runs in sequence the other scripts to start several simulations and compute an average of the results. Outcomes are saved in files: hops.X, howmanyrcv.X, tot_trasmission.X, trasmissionTime.X, slots.X, fmr.X.nodoDiControllo, bmr.X.nodoDiControllo.

startX.sh
- It calls monitor.pl to run a simulation with different parameters and create graphs

monitor.pl
- It is divided into subsections, each of which analyzes trace files and extracts (only) the information required to create the charts: for instance, only those lines of the trace file that regards the forwarders
	$matchedfw = ( $line =~ /^f\s(\d+\.?\d*)\s(\d+)\s(\d+)/);