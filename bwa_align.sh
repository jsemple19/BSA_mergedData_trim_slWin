#! /bin/bash
#modified 20170102 to align quality trimmed reads to both N2 and Hawaii genomes
#modified 20160721

#PS1="\W>"
#changes prompt to current directory and >
GENOME_VER="PRJNA13758.WS250"

#SOURCEDIR=/users/blehner/sequencing_data/Jennifer_Semple
DATADIR=/users/blehner/sequencing_data/Jennifer_Semple/mergedData_trim_slWin
BASEDIR=/users/blehner/jsemple/seqResults/mergedData_trim_slWin
GENOMEDIR=/users/blehner/jsemple/seqResults/GenomeBuilds/$GENOME_VER
#cd /host/Users/Jenny/Documents/CRG_files/MegaMate/2013-09-09/alignment

# to create env variable for bwa:
export BWA_HOME="/software/bl/el6.3/bwa_0.7.12"

#mkdir $BASEDIR/scripts
mkdir -p $BASEDIR/samFiles/$GENOME_VER
#mkdir $BASEDIR/tempData

genomefile=`ls $GENOMEDIR | grep 'c_elegans.*genomic\.fa$'`

# created merged fastq files as follows:
#cat $SOURCEDIR/2013-09-09/101F_4999_CAGATC_read1.fastq.gz $SOURCEDIR/2014-03-07/101F_4999_CAGATC_read1.fastq.gz > $DATADIR/1Fmerged_4999_CAGATC_read1.fastq.gz
#cat $SOURCEDIR/2013-09-09/101F_4999_CAGATC_read2.fastq.gz $SOURCEDIR/2014-03-07/101F_4999_CAGATC_read2.fastq.gz > $DATADIR/1Fmerged_4999_CAGATC_read2.fastq.gz
#cat $SOURCEDIR/2013-09-09/10ME_4998_ACAGTG_read2.fastq.gz $SOURCEDIR/2014-03-07/10ME_4998_ACAGTG_read2.fastq.gz > $DATADIR/MEmerged_4998_ACAGTG_read2.fastq.gz
#cat $SOURCEDIR/2013-09-09/10ME_4998_ACAGTG_read1.fastq.gz $SOURCEDIR/2014-03-07/10ME_4998_ACAGTG_read1.fastq.gz > $DATADIR/MEmerged_4998_ACAGTG_read1.fastq.gz

# then created subsampled files of same depth as new sequencing
#zcat MEmerged*read1* | head -27000000 > MEsubSampled_4998_ACAGTG_read1.fastq
#zcat MEmerged*read2* | head -27000000 > MEsubSampled_4998_ACAGTG_read2.fastq
#zcat 1Fmerged*read1* | head -27000000 > 1FsubSampled_4998_ACAGTG_read1.fastq
#zcat 1Fmerged*read2* | head -27000000 > 1FsubSampled_4998_ACAGTG_read2.fastq


# create arrays of file names
read1_files=(`ls $DATADIR/paired*r1.fastq.gz`)
read2_files=(`ls $DATADIR/paired*r2.fastq.gz`)

# number of filenames in a string (separated by spaces) (but chose to use arrays instead)
# length=`echo -n $read1_files | wc -w`

# #length of array
# length=`echo ${#read1_files[@]}`
# let length=length-1
# for i in `seq 0 $length`; do
# 	r1=`echo ${read1_files[$i]%_read1.fastq} | cut -f7 -d'/'`
# 	r2=`echo ${read2_files[$i]%_read2.fastq} | cut -f7 -d'/'`
# 	if [ "$r1" != "$r2" ]; then
# 		echo "name mismatch" $r1 $r2		
# 	else
# 		outfile=`echo "elegans_"$r1"_aln_pe.sam"`
# 		echo $genomefile
# 		$BWA_HOME/bwa mem -t 4 $BASEDIR/genomeSeq/elegans ${read1_files[$i]} ${read2_files[$i]} > $BASEDIR/samFiles/$outfile 		
# 	fi
# done

#to run on cluster:
i=$1
let i=i-1
r1=`echo ${read1_files[$i]%_r1.fastq.gz} | cut -f7 -d'/'`
r2=`echo ${read2_files[$i]%_r2.fastq.gz} | cut -f7 -d'/'`
if [ "$r1" != "$r2" ]; then
	echo "name mismatch" $r1 $r2		
else
	outfile=`echo "elegans_"$r1"_aln_pe.sam"`
	#echo $genomefile
	$BWA_HOME/bwa mem -t 4 $GENOMEDIR/elegans ${read1_files[$i]} ${read2_files[$i]} > $BASEDIR/samFiles/$GENOME_VER/$outfile 		
fi

