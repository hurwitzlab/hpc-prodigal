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

init_dir "$STDERR_DIR" "$STDOUT_DIR" 

if [[ ! -d $FASTA_DIR ]]; then
    mkdir -p $FASTA_DIR
fi

cd $FASTQ_DIR

FILES=$(mktemp)

find $FASTQ_DIR -name \*.fastq | cut -d'/' -f8 > $FILES

i=0
while read FILE; do
    let i++

    export FILE
    echo $FILE
    echo $PWD
    BASENAME=$(echo "$FILE" | cut -d'.' -f1)    

    JOB=$(qsub -v SCRIPT_DIR,FILE,FASTQ_DIR,FASTA_DIR -N qc_fastq -e "$STDERR_DIR/$BASENAME" -o "$STDOUT_DIR/$BASENAME" $SCRIPT_DIR/qc_fastq.sh)

    printf '%5d: %15s %-30s\n' $i $JOB $(basename $FILE)
done < $FILES

echo Submitted $i jobs.  Buenos dias!
