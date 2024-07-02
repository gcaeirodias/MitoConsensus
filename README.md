# MitoConsensus
A bash script to obtain mitochondrial consensus sequences from next generation sequencing single-end reads aligned to a reference mitogenome.

Several Next Generation Sequencing (NGS) methods produce mitocondrial sequence data, but often that data is ignored. The purpose of this pipeline is to provide a standerdized way to identify mitochondrial sequences from NGS data. This is done in four steps:
1. Alignment of demultiplexed raw reads to a reference mitogenome using bowtie2 (https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml);
2. Quality filtering of mapped reads;
3. Generation of mtDNA consensus sequence(s) for each individual;
4. Quality filtering of consensus sequences.

## Software needed to run 'MitoConsensus.sh'
- bowtie2
- samtools
- bedtools
- bcftools
- seqtk
- trimmomatic

## Assumptions about raw reads
'MitoConsensus.sh' only deals with single-end data.

## Before running 'MitoConsensus.sh'
Trasfer all individual FASTQ files (i.e., demultiplexed by individual) with raw reads to the same folder.
