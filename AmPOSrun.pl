#! /usr/bin/perl

$argc = @ARGV;
if ($argc != 1) { die("Usage:AmPOSrun.pl InputFile\n");}
#checking for the binaries in the path

$filename=$ARGV[0];
print "Yamcha formatting.....\n";
system("perl Tok_POS-YAM.pl $filename $filename.OUT");
system("perl convRaw2Yam4POS.pl $filename.OUT $filename.yamcha");
print  "POS tagging....\n";
system("crf_test -m model < $filename.yamcha >$filename.chunked");
system("perl lex-CRFconf.pl $filename.chunked $filename.chunked.LexCM");
system("perl yamPOS2out.pl $filename.chunked.LexCM $filename.POS");
print  "Done with POS tagging.... Output in $filename.POS\n";
print "Cleaning...\n";
# to delete the other files(intermediate files)
# you can see the intermediate files by commenting the next line...
system("rm $filename.OUT $filename.yamcha $filename.chunked $filename.chunked.LexCM");
print "Amazigh POS tagging done!!\n";
