# MitoConsensus
MitoConsensus is a bash script that uses standard bioinformatic tools to obtain mitochondrial consensus sequences from next generation sequencing single-end reads aligned to a reference mitogenome.

Several Next Generation Sequencing (NGS) methods produce mitocondrial sequence data, but often that data is ignored. The purpose of this script is to provide a standerdized way to identify mitochondrial sequences from NGS data, when possible. MitoConsensus.sh takes SAM files outputed by bowtie2 (or BAM files) as input and:
1. Filters mapped reads based on alignment quality and positions based depth of coverage;
2. Generats mtDNA consensus sequence(s) for each individual;
3. Filters cosensus sequences based on consensus base quality.

The output of MitoConsensus.sh (i.e., lenght of mtDNA sequences for each individual) depends greatly on the protocol used and target species. Some protocols are more prone to sequence mitochondrial fragments. MitoConsensus.sh was tested on nextRAD, ddRAD, a PCR free GBS, and Illumina shrot-read WGS (unpublished results). The results are not directly comparable because data was retrieved from different species but nextRAD and shrot-read WGS showed the best resutls.

## Software needed
- samtools
- bedtools
- bcftools
- trimmomatic
- seqtk


## Preparing the data
MitoConsensus.sh only deals with single-end data. Prior to run MitoConsensus.sh demultiplex reads by individual (one FASTQ file per individual), remove adapter and primer sequences as well as low quality bases, and align reads to a reference mitogenome using bowtie2. bowtie2 has to be used to align the reads because MitoConsensus.sh uses bowtie2 specific flag `XS:i` to filter out reads that aligned to the reference multiple times. When using a conspecific mitogenome I recomend to align reads using bowtie2 options `--local` and `--very-sensitive-local`. Finally, all BAM files resulting from bowtie2 should be in the same folder.

## Running MitoConsensus.sh
To facilitate the usage of this bash script, the first part is a set of shell varaibles to control several parameters and paths to files and folders. Bellow is the full set of variables:
~~~
IF
      Path to folder with SAM files outputed by bowtie2 (or BAM files) to be analysed. [Default: current directory]

REF
      Path to reference mitogenome FASTA file. [Default: current directory]

MAPQ
      Reads aligned to reference mitogenome with MAPQ smaller than this value will not be considered to build consensus sequences. Value to be passed to samtools [Default: 20]

DP
      Bases from aligned reads with depth of coverage smaller than this value will not be considered to build consensus sequences. [Default: 5]

LEADING
      Leading bases with quality bellow this value or N will be trimmed. Value to be passed to trimmomatic. [Default: 20]

TRAILING
      Trailing bases with quality bellow this value or N will be trimmed. Value to be passed to trimmomatic. [Default: 20]

MINLEN
      Reads with lenght below this value after removing leading and trailing bases will be filtered out. Value to be passed to trimmomatic. [Default: 50]

TRM
      Path to trimmomatic JAR file. [Default: current directory]

Q
      Value to be passed to seqtk. [Default: 20]

T  Number of threds to be used when parallel mode is allowed. [Default: 1]
~~~
  
MitoConsensus.sh outputs a series of BAM, FASTQ and FASTA files for each individual and a FASTA file including all sequences from all individuals that can be used for alignment and further filtering.

## Citation
Please cite the article where this script was first published: Osborne, Caeiro-Dias, Turner (2024), TITLE, JOURNAL, DOI
