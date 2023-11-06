#!usr/bin/perl
use warnings;
use File::Basename;
my %PE_PPE;
my $e = 0;
open(F1, "</Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/PE_PPE_repeat.bed");
while(<F1>){
        chomp;
        if($_=~m/^#/){
        }else{
        @a=split "\t",$_;
        my $start = $a[1] + 1;
        my $end = $a[2];
        my @id = split ";",$a[9];
        $PE_PPE{$id[0]}[0] = $start;
        $PE_PPE{$id[0]}[1] = $end;
        }
}
close F1;
open(Input, "$ARGV[0]") or die $!;
#my @suffix=".fix";
#$sample_name=basename("$ARGV[1]",@suffix);
#@patient_id=split "\_",$sample_name;
#my $month = substr($patient_id[1],1);
#open(Fix_snp,">$ARGV[1]") or die $!;
#open(V_snp,">$ARGV[2]") or die $!;
while(<Input>){
@a=split "\t",$_;
$a[4]=~s/%//;
@b=split "=",$a[7];
@c=split ":",$b[1];
foreach $key (keys %PE_PPE){
  if($a[1]>=$PE_PPE{$key}[0] and $a[1]<$PE_PPE{$key}[1]){
  $e = 1;
}
}

if($e == 0){
if(($c[0]>=1)&&($c[1]>=1)){
if($a[8]=~m/Pass=1E0/){
print "$_";

#if ($a[4]>98.5){
#  $a[4] = $a[4]/100;
#  print Fix_snp "@a[1..5] ";
#  print Fix_snp "$patient_id[0] ";
#  print Fix_snp $month;
#  print Fix_snp "\n";

#}
#elsif($a[4]>=1.5 and $a[4]<=98.5){
#$a[4] = $a[4]/100;
#print V_snp "@a[1..5] ";
#print V_snp "$patient_id[0] ";
#print V_snp $month;
#print V_snp "\n";
#}
}
}
}
$e = 0;
}
close Input;
#close Fix_snp;
#close V_snp;
