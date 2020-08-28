#!/usr/bin/perl -w
use File::Copy;

#constants
my $num_folds = 10;
my $step = 125;
my $i0 = 313;
my $dir = "./dataset";


%arraySen=();#--- hash table to contain all the sentences

$array = [];    #create new anonymous array ref
open(IN, $ARGV[0]);

$i = 1; # $i contains num sequences of sentences

while($_ = <IN>){
	if ($_ !~ m/^\n/ and ! eof(IN)) {
		push(@$array,$_);
			
	} 
	elsif(eof(IN)){
		push(@$array,$_);
		$arraySen{$i} = $array;
		$array = [];		
		$i++;
	}else{
		$arraySen{$i} = $array;
		$array = [];		
		$i++;
	}

}
close(IN);
$nbrSentences = countSentences($ARGV[0]);
print "$nbrSentences \n";	

create_working_dirs($num_folds);

$j=0;
for($i=$i0;$i<= countSentences($ARGV[0]); $i+= $step){
	Isentences($i,$j, %arraySen);
	$j++;
}
#------"moving ds$i.txt to $newlocation \n";----------- 
for($i= 0; $i < $num_folds ; $i++){
	$location = "ds$i.data";
	$newlocation = "$dir$i/$location";
	move($location, $newlocation) or die "move failed: $!";
	print "moving ds$i.data to $newlocation done \n";
	#printf ">test".$i."\n";
}
print "moving ds$i to $newlocation done!\n";

for ($i=0; $i<$num_folds;$i++){
	#used for SVM
	if (! -e "$dir$i/test$i.data"){
		`perl splitTT10.pl $dir$i\/ds$i\.data $i`;
	}
	# Coping Makefile file: a yamcha file to working directory	
	$location = "Makefile";
	$newlocation = "$dir$i/Makefile";
	copy($location, $newlocation) or die "move failed: $!";
	# Coping template file: a CRF file to working directory	
	$location = "template";
	$newlocation = "$dir$i/template";
	copy($location, $newlocation) or die "move failed: $!";
		
}


print "training the model which will be placed in each $dir directory...\n";
for ($i=0; $i<$num_folds;$i++){
	#create classifier
	if (! -e "$dir$i/case_study"){
	`make CORPUS=$dir$i/train$i.data MODEL=$dir$i/case_study train &\n`;
	}

	#run test and generating SVMout
	print "testing the model and generating SVMout in $dir$i directory...\n";
	if (! -e "$dir$i/SVMout"){
	`yamcha -o $dir$i/SVMout -m $dir$i/case_study.model < $dir$i/test$i.data`;
	print STDERR "\n";
	}
	# Evaluating the SVM output and generating SVM4POSeval
	print "Evaluating the SVM output and generating SVM4POSeval \n";
	if (-e "$dir$i/SVMout"){
	
		system("perl conlleval.pl -d \\\\s -r < $dir$i/SVMout > $dir$i/SVM4POSeval$i");	
	}
}

for ($i=0; $i< $num_folds;$i++){

	#create classifier
	print "training with CRF++... \n";
	if (! -e "$dir$i/model"){
	#crf_learn ./dataset1/template ./dataset1/train1.data model (script to use with the shel)
	`crf_learn $dir$i/template $dir$i/train$i.data $dir$i/model`;
	print "model generation...done!\n";
	}

	#run test
	print "testing... ";
	if (! -e "$dir$i/CRFout"){
	#crf_test -o CRFOut -m model test.data
	`crf_test -o $dir$i/CRFout -m $dir$i/model < $dir$i/test$i.data`;
	print "\n";
	}

	if (-e "$dir$i/CRFout"){
		print "Evaluating the CRF output and generating SVM4POSeval \n";
		system("perl conlleval.pl -d \\\\s -r < $dir$i/CRFout > $dir$i/CRF4POSeval$i");	
	}
}
# generation two files avg_accuracy for SVM and for CRF
system("perl avg_accuracySVM.pl");
system("perl avg_accuracyCRF.pl");


#---------return the number of \n so sentences----------
sub countSentences{
	my ($file) = $_[0];
	open(FILE, "<$file") or die "can't open $file: $!";
	my $count = 0;
	while(<FILE>){
		if ($_ =~ m/^\n$/ ) {
			$count++;	
		}
	}	
	close(FILE);
	return $count+1;
}

#---------print a given $i first sentences---------------
sub Isentences{
	open DS, ">ds$_[1].data";	
	foreach $key (sort keys %arraySen){
		
		unless($key > $_[0]){ 
			foreach (@{$arraySen{$key}}){
				printf DS $_;
			}
			
			printf DS "\n";
		}
	}

	close(DS);	
		
}

#------creating folders--------------
sub create_working_dirs{
	my ($num_folds) = @_;
	for(my$j=0; $j< $num_folds;$j++){
		mkdir("$dir$j");
	}
}

