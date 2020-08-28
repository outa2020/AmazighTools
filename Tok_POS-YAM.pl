#!/usr/bin/perl

$argc = @ARGV;
if ($argc != 2) { die("Usage:yamTok2out.pl infile outfile\n");}

# This is the labeled tokenised yamcha file 
open(IN,"< $ARGV[0]") || die("Unable to open 1 $ARGV[0]\n");

open(OUT,"> $ARGV[1]") || die("Unable to open 1 $ARGV[1]\n");


while($line= <IN>){
	chomp $line;
	if ($line ne ""){
		@words="";
		@words=split(/\s+/,$line);
		foreach $word (@words){		
			print OUT "$word\n";
			$count++;
		}
		print OUT "\n";
	}
}

close(IN);
close(OUT);

