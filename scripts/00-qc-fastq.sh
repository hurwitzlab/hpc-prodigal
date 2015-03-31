#!/bin/bash

# --------------------------------------------------
# 00-qc-fastq.sh
# 
# This script runs illumina QC on a directory
# of fastq files, runs the paired read analysis,
# then creates fasta/qual files from the paired
# fastq files
#
# For example:
# paired reads are in separate files:
# RNA_1_ACAGTG_L008_R1_001.fastq
# RNA_1_ACAGTG_L008_R2_001.fastq
#
# --------------------------------------------------

source ./config.sh

export CWD="$PWD"

PROG=$(basename $0 ".sh")
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dirs "$STDERR_DIR" "$STDOUT_DIR" 

if [[ ! -d $FASTA_DIR ]]; then
    mkdir -p $FASTA_DIR
fi

#
# NB: send the "R1" file and use the name to get the "R2" 
# file (if it exists)
#
FILES=$(mktemp)

find $FASTQ_DIR -name \*.fastq > $FILES

i=0
while read FILE; do
    let i++

    export FILE

    JOB=$(qsub -v SCRIPT_DIR,FILE,FASTA_DIR -N qc_fastq -e "$STDERR_DIR/$FILE" -o "$STDOUT_DIR/$FILE" $SCRIPT_DIR/qc_fastq.sh)

    printf '%5d: %15s %-30s\n' $i $JOB $(basename $FILE)
done < $FILES

echo Submitted $i jobs.  Buenos dias!
