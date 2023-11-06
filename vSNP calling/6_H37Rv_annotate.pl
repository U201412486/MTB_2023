#!usr/bin/perl
use warnings;

my %name;
my %des;
my %gene_type;
my $i=0;
my %start;
my %end;
my %strand;
my @igr;
my @gene;
my %code;
my @all;
my %geneha;
my %igrha;
my %comp;
$comp{"A"}="T";
$comp{"T"}="A";
$comp{"G"}="C";
$comp{"C"}="G";

open F1, $ARGV[0] or die $!; #open Tuberculist_new_20150307
while(<F1>){
	chomp;
	@a=split "\t",$_;
	$start{$a[0]}=$a[3];
	$end{$a[0]}=$a[4];
	$strand{$a[0]}=$a[2];
	$name{$a[0]}=$a[1];
	$des{$a[0]}=$a[5];
	$gene_type{$a[0]}=$a[6];
	push(@gene, $a[0]);
	$geneha{$a[0]}=1;
	if($i>0){								#数基因间区域
		if($a[3]>$end{$gene[$i-1]}){
			$j="$gene[$i-1]-$gene[$i]";
			$igrha{$j}=1;
			push(@igr,$j);
			$start{$j}=$end{$gene[$i-1]}+1;
			$end{$j}=$a[3]-1;
			}
		}
	$i++;	
	}
close F1;

@all=(@gene,@igr);

open F2, $ARGV[1] or die $!; #open genetic_code
while(<F2>){
	chomp;
	@a=split "\t",$_;
	$code{$a[0]}=$a[1];
	}
close F2;

open F3, $ARGV[2] or die $!; #open genome.fasta
while(<F3>){
	chomp;
	if($_=~m/>/){
		}
		else{
			$genome.=$_;
			}
	}
close F3;

my $k=0; #用来判定对该位点是否存在两个基因的重叠区域。k=0时是第一次注释，k=1是是第二次注释。
my $n=0;


print "locus\tref_base\talt_base\tfrequency\tcoverage\tpatient_id\tstage\tcodon_number\tanocid_type\tanocid\tcondon_change\tgenes\tgene_name\tdescription\tgene_type\n";
open F4, $ARGV[3] or die $!; # open mutation_list
while(<F4>){
	chomp;
	@a=split " ",$_;
        if ($a[0] > 4410929){print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t-\t---\t---\t---\t---\t---\tchromsome_end\tother"}
	foreach $i(@gene){
		if(($a[0]>=$start{$i})&&($a[0]<=$end{$i})){ $n++;   # mutation location
			if(($gene_type{$i}!~m/protein_coding/) && ($n==0) ){
				print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t-\t---\t---\t---\t$i\t$name{$i}\t$des{$i}\t$gene_type{$i}";
				}elsif($k==0){
				if($strand{$i} eq "+"){
					$length=$end{$i}-$start{$i}+1;
					$seq=substr($genome,$start{$i}-1,$length);
					$loci=$a[0]-$start{$i}+1;         #loci
					$count=$loci/3;
					$ct=int($loci/3);
					$remain=$loci%3;
					if($count==$ct){
						$codon=$ct;
						$wd=substr($seq,$loci-3,3);
						$mt=substr($wd,0,2);
						$mt.=$a[2];
						}
						elsif($remain==1){
							$codon=$ct+1;
							$wd=substr($seq,$loci-1,3);
							$mt=$a[2];
							$mt.=substr($wd,1,2)
						}
						elsif($remain==2){
							$codon=$ct+1;
							$wd=substr($seq,$loci-2,3);
							$mt=substr($wd,0,1);
							$mt.=$a[2];
							$mt.=substr($wd,2,1);
						}
					}
				elsif($strand{$i} eq "-"){
					$length=$end{$i}-$start{$i}+1;
					$sequence=substr($genome,$start{$i}-1,$length);
					$seq=reverse $sequence;
					$loci=$end{$i}-$a[0]+1;         #loci
					$count=$loci/3;
					$ct=int($loci/3);
					$remain=$loci%3;
					if($count==$ct){
						$codon=$ct;
						$wd=substr($seq,$loci-3,3);
						$mt=substr($wd,0,2);
						$mt.=$a[2];
						}
						elsif($remain==1){
							$codon=$ct+1;
							$wd=substr($seq,$loci-1,3);
							$mt=$a[2];
							$mt.=substr($wd,1,2)
						}
						elsif($remain==2){
							$codon=$ct+1;
							$wd=substr($seq,$loci-2,3);
							$mt=substr($wd,0,1);
							$mt.=$a[2];
							$mt.=substr($wd,2,1);
						}
					$wd=~tr/ATGC/TACG/;
					$mt=~tr/ATGC/TACG/;
					}
if($code{$wd} eq $code{$mt}){
$type="Synonymous";
}else{
$type="Nonsynonymous";
}
				print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$codon\t$type\t$code{$wd}-$code{$mt}\t$wd-$mt\t$i\t$name{$i}\t$des{$i}\t$gene_type{$i}";
$type="";				
}
			if($k==1){
				if($strand{$i} eq "+"){
					$length=$end{$i}-$start{$i}+1;
					$seq=substr($genome,$start{$i}-1,$length);
					$loci=$a[0]-$start{$i}+1;            #loci
					$count=$loci/3;
					$ct=int($loci/3);
					$remain=$loci%3;
					if($count==$ct){
						$codon=$ct;
						$wd=substr($seq,$loci-3,3);
						$mt=substr($wd,0,2);
						$mt.=$a[2];
						}
						elsif($remain==1){
							$codon=$ct+1;
							$wd=substr($seq,$loci-1,3);
							$mt=$a[2];
							$mt.=substr($wd,1,2)
						}
						elsif($remain==2){
							$codon=$ct+1;
							$wd=substr($seq,$loci-2,3);
							$mt=substr($wd,0,1);
							$mt.=$a[2];
							$mt.=substr($wd,2,1);
						}
					}
				elsif($strand{$i} eq "-"){
					$length=$end{$i}-$start{$i}+1;
					$sequence=substr($genome,$start{$i}-1,$length);
					$seq=reverse $sequence;
					$loci=$end{$i}-$a[0]+1;      #loci
					$count=$loci/3;
					$ct=int($loci/3);
					$remain=$loci%3;
					if($count==$ct){
						$codon=$ct;
						$wd=substr($seq,$loci-3,3);
						$mt=substr($wd,0,2);
						$mt.=$a[2];
						}
						elsif($remain==1){
							$codon=$ct+1;
							$wd=substr($seq,$loci-1,3);
							$mt=$a[2];
							$mt.=substr($wd,1,2)
						}
						elsif($remain==2){
							$codon=$ct+1;
							$wd=substr($seq,$loci-2,3);
							$mt=substr($wd,0,1);
							$mt.=$a[2];
							$mt.=substr($wd,2,1);
						}
					$wd=~tr/ATGC/TACG/;
					$mt=~tr/ATGC/TACG/;	
					}
if($code{$wd} eq $code{$mt}){
$type="Synonymous";
}else{
$type="Nonsynonymous";
}
## by sunxh				print "\t$codon\t$type\t$code{$wd}-$code{$mt}\t$wd-$mt\t$i\t$name{$i}\t$des{$i}\t$gene_type{$i}";
$type="";				
}
			$k++;
                      
			}
### 只要是基因内部，舍去基因间 #### by sunxh 20220401
		}
		$k=0;
                if($n==0){
		foreach $j(@igr){
			if(($a[0]>=$start{$j})&&($a[0]<=$end{$j})){
				@b=split "-",$j;
				$left=$a[0]-$end{$b[0]};
				$right=$start{$b[1]}-$a[0];
				print "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t-\t---\t---\t$strand{$b[0]}$left-$right$strand{$b[1]}\t$j\t$name{$b[0]}-$name{$b[1]}\t$des{$b[0]}##$des{$b[1]}\t$gene_type{$b[0]}##$gene_type{$b[1]}";
				}
			}}
                $n=0;
		print "\n";	
}
close F4;








