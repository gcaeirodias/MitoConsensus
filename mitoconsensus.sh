#!/bin/bash

######################################
## Variables with parameters to use
######################################
IF=./
FILE=bam
MAPQ=20
DP=5
LEADING=20
TRAILING=20
MINLEN=50
Q=20
P=example_combined_mtDNA
T=1
TRM=./jar_trimmomatic/trimmomatic-0.39.jar

######################################
## Output folders
######################################
# Create output folders if they do not exist.
cd $IF
mkdir -p filt_reads consensus filt_consensus

######################################
## Reads quality filters
######################################
# Function to filter reads by mapping quality and single alignments using bowtie2 'XS:i' flag. Note that this works only for single-end read data.
filter_reads() {
    local sbam=$1
    local mapqfilt="filt_reads/${sbam%%.bam}_MAPQfilt.bam"
    local output_file="filt_reads/${sbam%%.bam}_single_alignments.bam"
    samtools view -q $MAPQ -b ${sbam} -o "$mapqfilt"
    samtools view -h "$mapqfilt" | grep -v "XS:i:" | samtools view -b -o "$output_file"
     if [[ $? -eq 0 ]]; then
       echo "${sbam%%.bam} map filtering successful."
    else
       echo "Error in ${sbam%%.bam} map filtering."
       return 1
    fi
}

export -f filter_reads
parallel filter_reads ::: *.$FILE

# Function to filter bases by depth of coverage.
filter_depth() {
    local sabam=$1
    local bed="${sabam%%_single_alignments.bam}_mapped.bed"
    local output_file="${sabam%%_single_alignments.bam}_DPfilt.bam"
    bedtools genomecov -ibam ${sabam} -bg | awk -v DP="$DP" '$4 > DP-1' | tr ' ' '\t' | awk '{print $1,$2,$3}' | tr ' ' '\t' | bedtools merge > "$bed"
    bedtools intersect -wa -a ${sabam} -b "$bed" > "$output_file"
    if [[ $? -eq 0 ]]; then
       echo "${sabam%%_single_alignments.bam} depth filtering successful."
    else
       echo "Error in ${sabam} depth filtering."
       return 1
    fi
}

export -f filter_depth
cd filt_reads
parallel filter_depth ::: *_single_alignments.bam

######################################
## Consensus
######################################
# Function to create FASTQ files with mtDNA consensus sequences.
create_consensus() {
    local dpbam=$1
    local sort="${dpbam%%.bam}_sort.bam"
    local output_file="../consensus/${dpbam%%_DPfilt.bam}_consensus.fastq"
    samtools sort ${dpbam} -o "$sort"
    samtools consensus -f fastq -A --P-het 0 "$sort" > "$output_file"
    if [[ $? -eq 0 ]]; then
       if [[ -s "$output_file" ]]; then
          echo "${dpbam%%_DPfilt.bam}_consensus.fastq successfully created."
       else
          echo "${dpbam%%_DPfilt.bam}_consensus.fastq is empty."
       fi
    else
       echo "Error creating ${dpbam%%_DPfilt.bam}_consensus.fastq."
       return 1
    fi
    rm "$sort"
}

export -f create_consensus
parallel create_consensus ::: *_DPfilt.bam

######################################
## Consensus sequences quality filters
######################################
# Convert multi-line FASTQ to 4-line format, trim consensus sequences on each side if base quality is lower than 'LEADING' and 'TRAILING', convert to .FASTA and mask remaining bases of quality lower than 'Q' to N.
cd ../consensus
for fastq in *_consensus.fastq
    do

    # Convert multi-line FASTQ to 4-line format
    seqtk seq -l0 ${fastq} > ../filt_consensus/${fastq%%.fastq}_4L.fastq
    if [[ $? -eq 0 ]]; then
        if [[ -s "../filt_consensus/${fastq%%.fastq}_4L.fastq" ]]; then
            echo "${fastq%%.fastq} FASTQ 4-line format successfully created."
        else
            echo "${fastq%%.fastq} FASTQ empty."
        fi
    else
        echo "Error converting ${fastq} to 4-line format."
        return 1
    fi

    # Trim
    java -Xmx20g -jar $TRM SE -threads $T -phred33 ../filt_consensus/${fastq%%.fastq}_4L.fastq ../filt_consensus/${fastq%%.fastq}_trim.fastq LEADING:$LEADING TRAILING:$TRAILING SLIDINGWINDOW:5:10 MINLEN:$MINLEN

    # Mask bases to N based on quality and convert to FASTA.
    seqtk seq -a -q $Q -n N ../filt_consensus/${fastq%%.fastq}_trim.fastq > ../filt_consensus/${fastq%%.fastq}.fasta
    if [[ $? -eq 0 ]]; then
       if [[ -s "../filt_consensus/${fastq%%.fastq}.fasta" ]]; then
          echo "${fastq%%.fastq}.fasta successfully created."
       else
          echo "${fastq%%.fastq}.fasta is empty."
       fi
    else
       echo "Error creating ${fastq%%.fastq}.fasta."
       return 1
    fi

    seqtk fqchk -q 0 ../filt_consensus/${fastq%%.fastq}_trim.fastq > ../filt_consensus/${fastq%%.fastq}_fastq_summary.txt

    rm ../filt_consensus/${fastq%%.fastq}_trim.fastq ../filt_consensus/${fastq%%.fastq}_4L.fastq
done

# Function to modify FASTA headers.
modify_headers() {
    local fasta=$1
    HEADER=$(head -1 $fasta)
    sed -i "s/$HEADER/>${fasta%%.fasta}_mtDNA/" $fasta
}
