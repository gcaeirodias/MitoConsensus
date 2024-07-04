# MitoConsensus
MitoConsensus is a bash script that uses standard bioinformatic tools to obtain mitochondrial consensus sequences from next generation sequencing single-end reads aligned to a reference mitogenome.

Several Next Generation Sequencing (NGS) methods produce mitocondrial sequence data, but often that data is ignored. The purpose of this script is to provide a standerdized way to identify mitochondrial sequences from NGS data. MitoConsensus.sh takes SAM files outputed by bowtie2 (or BAM files) as input and:
1. Filters mapped reads based on alignment quality and positions based depth of coverage;
2. Generats mtDNA consensus sequence(s) for each individual;
3. Filters cosensus sequences based on consensus base quality and .

## Software needed
- samtools
- bedtools
- bcftools
- trimmomatic
- seqtk


## Preparing the data
MitoConsensus.sh only deals with single-end data. Prior to run MitoConsensus.sh demultiplex reads by individual (one FASTQ file per individual), remove adapter and primer sequences as well as low quality bases, and align reads to a reference mitogenome using bowtie2. bowtie2 has to be used to align the reads because MitoConsensus.sh uses bowtie2 specific flag `XS:i` to filter out reads that aligned to the reference multiple times. When using a conspecific mitogenome I recomend to align reads using bowtie2 options `--local` and `--very-sensitive-local`. Finally, all BAM files resulting from bowtie2 should be in the same folder.

## Running MitoConsensus.sh
The first part of the script is to set the shell varaibles to pass to commands. Modify each one acordingly Here is the full set of variables:
~~~
IF  Path to folder with SAM files outputed by bowtie2 (or BAM files) to be analysed. [Default: current directory]

REF   Path to reference mitogenome FASTA file. [Default: current directory]

MAPQ  Reads aligned to reference mitogenome with MAPQ smaller than this value will not be considered to build consensus sequences. [Default: 20]

DP  Bases from aligned reads with depth of coverage smaller than this value will not be considered to build consensus sequences. [Default: 5]

T  Number of threds to be used when parallel mode is allowed. [8]

TRM  Path to Trimmomatic JAR file. [Default: current directory]
~~~
  
MitoConsensus.sh outputs a series of BAM, FASTQ and FASTA files for each individual and a FASTA file including all sequences from all individuals that can be used for alignment and further filtering.

## Citation
Please cite the article where this script was first published: Osborne, Caeiro-Dias, Turner (2024), TITLE, JOURNAL, DOI
