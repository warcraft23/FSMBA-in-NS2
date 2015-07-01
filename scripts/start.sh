#!/bin/bash

./start0.sh && ./start10.sh && ./start20.sh && ./start30.sh && ./start50.sh 

/usr/bin/perl ./avg.pl bmr.0.node200 bmr.10.node200 bmr.20.node200 bmr.30.node200 bmr.50.node200 -f 2
/usr/bin/perl ./avg.pl fmr.0.node200 fmr.10.node200 fmr.20.node200 fmr.30.node200 fmr.50.node200 -f 2 
/usr/bin/perl ./avg.pl hops.0 hops.10 hops.20 hops.30 hops.50 -f 1 
/usr/bin/perl ./avg.pl howmanyrcv.0 howmanyrcv.10 howmanyrcv.20 howmanyrcv.30 howmanyrcv.50 -f 1 
/usr/bin/perl ./avg.pl slots.0 slots.10 slots.20 slots.30 slots.50 -f 1 
/usr/bin/perl ./avg.pl tot_trasmission.0 tot_trasmission.10 tot_trasmission.20 tot_trasmission.30 tot_trasmission.50 -f 1 
/usr/bin/perl ./avg.pl trasmissionTime.0 trasmissionTime.10 trasmissionTime.20 trasmissionTime.30 trasmissionTime.50 -f 1



