#!/usr/bin/perl

$argc = @ARGV;
if ($argc != 2) { die("Usage: script.pl InputFile OutputFile\n");}

#--------------------------------------------
$file_lexicon= "lex8k";
# to put oov_file in a hash
$threshold = 0.92; # $threshold is the threshold from which we look in the lexicon
%HashLex=();
open(IN,'<:utf8',"$file_lexicon");

#crf_test -o CRFOut -m model T_0
print  "POS tagging with -v1 option....\n";	
`crf_test -v1 -m model < $ARGV[0] > $ARGV[0].V1` ;

@words ="";
$word = "";
$tag = "";

while (<IN>) {
	$line = $_;
	chomp($line);
	if ($line ne "") {
		@words = split(/\s+/,$line);
		$word = shift(@words); # word is first item on line
	 	$tag = pop(@words);    # tag is last item on line
		#print "$word-------$tag\n"; #---just for the test
		   	
		if (not defined $HashLex{$word}){ 
		   	$HashLex{$word} = $tag;
		}
	}  
}

# close IN file
close(IN);


#-----------------------------------------

# This is the input file
open(IN1,'<:utf8', "$ARGV[0].V1") || die("Unable to open  $ARGV[0]\n");

$word_conf = 0;

$text ="";
# to put the IN file in $text variable.
while ($line=<IN1>){
	if ($line !~ /#\s(\d).(\d+)/){
		$text.= $line;
	}
}
close (IN1);
open(OUT,'>:utf8',$ARGV[1]);

@sentences = split('\\n\\n', $text);

foreach $sentence  (@sentences) {
	if ($sentence ne ""){	
		@words ="";
		@words= split (/\n/, $sentence);
		foreach $word (@words){		
					
			if ($word =~ /(.+)\t(\w+)\/(\d)\.(\d{6})/) { #$2 contains the number we need	
				$word_conf = (int($4)/1000000.0);
				@wordsCons = split(/\s+/,$word);
				$w1 = shift(@wordsCons); # word is first item on line
				if ($word_conf > $threshold){
					print OUT "$1\t$2\n" ;
				}else {
					
					if (defined $HashLex{$w1}){ 
					   	$NewTag = $HashLex{$w1};
						print OUT "$1\t"."$NewTag\n";
					} else{print OUT "$1\t$2\n";}
								
				}				 
			}
		}
		print OUT "\n";# for marking the end of sentence
	}
}

close(OUT);




