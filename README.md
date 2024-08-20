# MitoConsensus
MitoConsensus is a shell script that produces mithocondrial consensus sequences from high-throughput reduced representation sequencing methods using single-end sequencing after alignment to a reference mitogenome. MitoConsensus uses the Bayesian approach implemented in samtools to produce mitochondrial consensus sequences and other standard bioinformatic tools to filter reads prior to consensus and to filter consensus sequences in FASTQ format.

Several high-throughput reduced representation sequencing methods produce mitocondrial sequence data, but often that data is ignored. The purpose of this script is to provide a standerdized way to identify mitochondrial sequences from reduced representation sequencing data, when possible. MitoConsensus takes as input SAM files outputed by bowtie2 or BAM files converted from bowtie2 SAM files:
1. Filters mapped reads based on alignment quality, number of alignments, and position depth of coverage;
2. Generats mtDNA consensus sequence(s) for each individual;
3. Filters consensus sequences based on consensus base quality.

The output of MitoConsensus (i.e., the lenght of mtDNA sequences for each individual) depends greatly on the protocol used and target species. Some protocols are more prone to sequence mitochondrial fragments. MitoConsensus was tested on nextRAD, ddRAD, and a PCR free GBS (unpublished results). The results are not directly comparable because data was retrieved from different species but more and longer reads were obtained from nextRAD.

## Tools needed
- GNU parallel
- samtools
- bedtools
- bcftools
- trimmomatic
- seqtk

## Preparing the data
MitoConsensus deals only with single-end data. Prior to run MitoConsensus demultiplex reads by individual (one FASTQ file per individual), remove adapter and primer sequences as well as low quality bases, and align reads to a reference mitogenome using bowtie2. bowtie2 has to be used to align the reads because MitoConsensus uses bowtie2 specific flag `XS:i` to filter out reads that aligned to the reference multiple times. When using a conspecific mitogenome I recomend to align reads using bowtie2 options `--local` and `--very-sensitive-local`. Finally, all BAM files resulting from bowtie2 should be in the same folder.

## Running MitoConsensus
To facilitate the usage of this bash script, the first part is a set of shell varaibles to control several parameters and the path to the folder with alignment files. Bellow is the full set of variables:
~~~
IF
      Path to folder with SAM files outputed by bowtie2 (or BAM files) to be analysed.
      [Value used in the script: current directory]

FILE
      The format of individual alignment files. The options are 'bam' or 'sam'.
      [Value used in the script: bam]

MAPQ
      Reads aligned to reference mitogenome with MAPQ smaller than this value will not be considered to build consensus sequences.
      Value to be passed to samtools.
      [Value used in the script: 20]

DP
      Bases from aligned reads with depth of coverage smaller than this value will not be considered to build consensus sequences.
      [Value used in the script: 5]

LEADING
      Leading bases with quality bellow this value or N will be trimmed. Value to be passed to trimmomatic.
      [Value used in the script: 20]

TRAILING
      Trailing bases with quality bellow this value or N will be trimmed. Value to be passed to trimmomatic.
      [Value used in the script: 20]

MINLEN
      Reads with lenght below this value after removing leading and trailing bases will be filtered out.
      Value to be passed to trimmomatic.
      [Value used in the script: 50]

TRM
      Path to trimmomatic JAR file.
      [Value used in the script: current directory]

Q
      Bases from consensus sequences in FASTQ format with PHRED quality score lower than this value will be masked to 'N'. 
      Value to be passed to seqtk.
      [Value used in the script: 20]

T
      Number of threds to be used when parallel mode is allowed.
      [Value used in the script: 1]
~~~
  
MitoConsensus outputs a series of BAM, FASTQ and FASTA files for each individual and a combined FASTA file including all sequences from all individuals that can be used for alignment and further filtering. Further validation of variable positions, particularly low frequency variants, is strongly recomended.

## Citation
Please cite the article where this script was first published: Osborne MJ, Caeiro-Dias G, Turner TF (2024). Mitogenomics of a declining species with boom-bust population dynamics. In review.

## Contact
Send your questions, suggestions, or comments to gcaeirodias@unm.edu
