#! /bin/bash
#last modified 20160701
#mpileup under bcftools for multiallelic calling with no prior

GENOME_VER="PRJNA13758.WS250"
BASEDIR=/users/blehner/jsemple/seqResults/mergedData_trim_slWin
GENOMEDIR=/users/blehner/jsemple/seqResults/GenomeBuilds/$GENOME_VER

genomefile=`ls $GENOMEDIR/*.fa`

# to create env variable for samtools:
export SAMTOOLS_HOME="/software/bl/el6.3/samtools-1.3.1"

mkdir -p $BASEDIR/bamFiles/$GENOME_VER
mkdir -p $BASEDIR/vcfFiles/$GENOME_VER

#index genome
#$SAMTOOLS_HOME/samtools faidx $genomefile

# create arrays of file names
samfiles=(`ls $BASEDIR/samFiles/$GENOME_VER/*.sam`)

# ordinal number of samFile input from command line arg
i=$1
let i=i-1
r1=`echo ${samfiles[$i]%_*_aln_pe.sam} | cut -f9 -d'/'`
outbam=`echo $BASEDIR/bamFiles/$GENOME_VER/$r1".bam"`

##convert samfiles to bamfiles (slow):
#$SAMTOOLS_HOME/samtools view -b -S -o $outbam ${samfiles[$i]}

##sort the bam file:
outsort=`echo $BASEDIR/bamFiles/$GENOME_VER/$r1".sorted.bam"`	
#$SAMTOOLS_HOME/samtools sort $outbam -T $outsort -o $outsort 

##count variants at SNP sites from .bed file
#bedfile=`ls $GENOMEDIR/SNVs*.pos`  # 300,000 SNVs from Hawaii genome paper
#bedfile=`ls $GENOMEDIR/AnnSNPs*.pos` # 172,000 SNVs from genome gff annotation
bedfile=`ls $GENOMEDIR/SNVs_N2-CB4856*.pos`

#names of sorted files now end in .bam
#insorted=`echo $outsort".bam"`

#create variant count file name
vcffile=`echo $BASEDIR/vcfFiles/$GENOME_VER/$r1"_raw.vcf"`

export BCFTOOLS_HOME="/software/bl/el6.3/bcftools-1.3.1"

#run samtools mpileup and bcftools - NOT GOOD FOR MULTIALLELIC CALLNG. need bcftools call rather than view
#$SAMTOOLS_HOME/samtools mpileup -f $genomefile -l $bedfile -uBg $outsort | $BCFTOOLS_HOME/bcftools view -> $vcffile

#run in two steps. first mpileup. then index the outputed bam file. then bcftools multiallelic calling
mpfile=`echo $BASEDIR/vcfFiles/$GENOME_VER/$r1"_mp.bcf"`
$SAMTOOLS_HOME/samtools mpileup -f $genomefile -Q 20 -l $bedfile -BIg $outsort -o $mpfile

$BCFTOOLS_HOME/bcftools index $mpfile

# multiallelic calling with prior ignored (-P0)
$BCFTOOLS_HOME/bcftools call -R $bedfile -m -P0 -Ov $mpfile -o $vcffile
