# MitoConsensus
A bash script to obtain mitochondrial consensus sequences from next generation sequencing single-end reads aligned to a reference mitogenome.

Several Next Generation Sequencing (NGS) methods produce mitocondrial sequence data, but often that data is ignored. The purpose of this pipeline is to provide a standerdized way to identify mitochondrial sequences from NGS data. This is done in four steps:
1. Quality filtering of mapped reads;
3. Generation of mtDNA consensus sequence(s) for each individual;
4. Quality filtering of consensus sequences.

## Software needed to run 'MitoConsensus.sh'
- trimmomatic
- samtools
- bedtools
- bcftools
- seqtk


## Preparing data to run 'MitoConsensus.sh'
`MitoConsensus.sh` only deals with single-end data. Prior to run `MitoConsensus.sh` demultiplex reads by individual (one FASTQ file per individual), remove adapter and primer sequences as well as low quality bases, and align reads to a reference mitogenome using `bowtie2`. `bowtie2` has to be used to align the reads because `MitoConsensus.sh` uses `bowtie2` specific flag `XS:i` to filter out reads that aligned to the reference multiple times. When using a conspecific mitogenome we recomend to align reads using `bowtie2` options `--local` and `--very-sensitive-local`. Finally, all BAM files resulting from `bowtie2` should be in the same folder.

## Running 'MitoConsensus.sh'
The first part of the script is to set the varaibles to pass to commands that define paths to files ond folders. Here is the full set of variables:
~~~
IF=[path/to/folder/with/fastq/files]
OF=[path/to/folder/where/to/save/bam/files]
REF=[path/to/reference/mitogenome/fasta/file]
Q=
T=
~~~
The second part is to align 
