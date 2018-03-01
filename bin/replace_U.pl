#!/usr/bin/perl
use POSIX;

($aln_file)=@ARGV;

system("mv $aln_file tmp_file");

#_________ Read file and replace U characters to X _________#

$/=">";
open OUT, ">>", $aln_file or die $!; 
open REFseq,  "tmp_file" or die $!; 
$count=0;
while (<REFseq>)
{   
    $entry=$_; 
    #chop $entry;
    $entry= ">"."$entry";
    $entry=~/>(.+?)\n(\C*)/g;
    $title=$1;$sequence=$2; $sequence=~s/U/X/g;
    if ($title ne "" && $sequence ne "" && $count!=0){  print OUT $title."\n".$sequence; $count++;  }
    if ($title ne "" && $sequence ne "" && $count==0){  print OUT ">".$title."\n".$sequence;  $count++;}
    
}
close(REFseq);
system("rm tmp_file");
