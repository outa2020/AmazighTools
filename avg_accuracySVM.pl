#!/usr/bin/perl -w

#constants
my $seperator = '#';
my $num_folds = 4;
my $dir = "./fold";
#SVM4POSeval0 to CRF4POSeval_num_fols


open avg_accuracy, ">avg_accuracySVM";
printf avg_accuracy "fold_i| accuracy\n";
printf avg_accuracy "----------------\n";

$accuracy = 0;
$accuracy_cumul = 0;
for(my $i=0; $i<$num_folds; $i++){
	
	open(FILE, "<./$dir$i/SVM4POSeval$i") or die "can't open  the file: $!";
	
	while(<FILE>){
		
		if($_ =~/accuracy:(\s+)(\d+)\.(\d+)%;/){ 	# we look for the number after accuracy of the file	
			$accuracy = $2 + $3/100;
			printf avg_accuracy "fold$i | $accuracy\n";
			$accuracy_cumul +=$accuracy;
			last;
		}
	}
	
	close(FILE);
}
$avg_accuracy = $accuracy_cumul/$num_folds;

close(avg_accuracy);

