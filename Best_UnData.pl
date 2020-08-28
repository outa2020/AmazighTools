#!/usr/bin/perl

$argc = @ARGV;
if ($argc != 1) { die("Usage: script.pl sentences\n");}

#open(IN,'<:utf8', "$ARGV[0]") || die("Unable to open  $ARGV[0]\n");
#open(IN2,'<:utf8', "$ARGV[1]") || die("Unable to open  $ARGV[1]\n");

#model was obtained by training the model on Tr_0(containing 60% of L0)
$filename = $ARGV[0];
system("perl convRaw2Yam4POS.pl $filename $filename.WLF");
print  "POS tagging with -v1 option....\n";
system("crf_test -v1 -m model < $filename.WLF >$filename.chunked"); # option -n 2 to have the 2 best choices

#system("perl BestSent.pl $filename.chunked $filename.BS $filename.rest"); # script used to obtain the best sentence for learning the model
#system("rm $filename.crf $filename.BS $filename.chunked");
