#!/usr/bin/perl

$argc = @ARGV;
if ($argc != 3) { die("Usage: script.pl sentences sentence-BS sentences_rest\n");}

open(IN,'<:utf8', "$ARGV[0]") || die("Unable to open  $ARGV[0]\n");
# This is the output file of best sent for learning
open(OUT,'>:utf8', "$ARGV[1]") || die("Unable to open  $ARGV[1]\n");
open(OUT1,'>:utf8', "$ARGV[2]") || die("Unable to open  $ARGV[2]\n");
$max = 0;
$read = 0;
$sent = "";
$num_line = 0;
while ($line=<IN>){
		if ($line =~ /#\s(\d).(\d+)/){
			if ($2 > $max){
				$max = $2;
				$read = 1;
				$sent = "";
				$num_line = $.;
			}else{ $read = 0;}
		}else{
			if ($read == 1){
				$sent .= $line;
			}
		}
}

$sent =~ s/(.+)\/0.(\d+)\n+/$1\n/g;
@lines_BS = split("\n",$sent); 
$nbr_lines_BS = $#lines_BS + 1;#to know how many lines are there in the best sentence for self training( by conting \n plus 1 
#print "$num_line---$nbr_lines_BS\n";
seek(IN,0,0); # to return to the begining of the file
@DATA = <IN>;
@DATA_delated = splice(@DATA, $num_line, $nbr_lines_BS);

$otherSent =""; 
foreach $line_data (@DATA){
	if ($line_data =~ /#\s(\d).(\d+)/){
	}else{
		@words = split("\t", $line_data);
		$otherSent .="@words[0]\n";	
	}
}
$otherSent  =~ s/(.+)\n\n+/$1\n\n/g;
$otherSent =~ s/\n+(.+)/$1/; 
#$otherSent =~ s/(.+)\n*/$1/; 
print OUT1 $otherSent; 
print OUT $sent;

close(IN);
close(OUT);
close(OUT1); 
