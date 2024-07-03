# MitoConsensus
A bash script to obtain mitochondrial consensus sequences from next generation sequencing single-end reads aligned to a reference mitogenome.

Several Next Generation Sequencing (NGS) methods produce mitocondrial sequence data, but often that data is ignored. The purpose of this script is to provide a standerdized way to identify mitochondrial sequences from NGS data. MitoConsensus.sh takes SAM files outputed by bowtie2 (or BAM files) as input and:
1. Filters mapped reads based on alignment quality and positions based depth of coverage;
2. Generats mtDNA consensus sequence(s) for each individual;
3. Filters cosensus sequences based on consensus base quality and .

## Software needed to run 'MitoConsensus.sh'
- samtools
- bedtools
- bcftools
- trimmomatic
- seqtk


## Preparing data to run 'MitoConsensus.sh'
`MitoConsensus.sh` only deals with single-end data. Prior to run `MitoConsensus.sh` demultiplex reads by individual (one FASTQ file per individual), remove adapter and primer sequences as well as low quality bases, and align reads to a reference mitogenome using `bowtie2`. `bowtie2` has to be used to align the reads because `MitoConsensus.sh` uses `bowtie2` specific flag `XS:i` to filter out reads that aligned to the reference multiple times. When using a conspecific mitogenome I recomend to align reads using `bowtie2` options `--local` and `--very-sensitive-local`. Finally, all BAM files resulting from `bowtie2` should be in the same folder.

## Running 'MitoConsensus.sh'
The first part of the script is to set the shell varaibles to pass to commands. Here is the full set of variables:
~~~
IF=[path/to/folder/with/fastq/files]
OF=[path/to/folder/where/to/save/bam/files]
REF=[path/to/reference/mitogenome/fasta/file]
Q=
T=
DP=
~~~
MitoConsensus.sh takes BAM files outputed by bowtie2 as input and Step 1 consist in  
