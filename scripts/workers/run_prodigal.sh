#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard 
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=12:mem=23gb:pcmem=2gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00

echo Started `date`

echo Host `hostname`

#
# prodigal parameters
#
OUTPUT_FMT="gff"
PRODIGAL_PROCEDURE="meta"

cd "$SPLIT_FA_DIR"

FASTA=`head -n +${PBS_ARRAY_INDEX} $FILES_LIST | tail -n 1`
FASTA_BASE=$(echo "$FASTA" | cut -d'.' -f1)

FILE="$SPLIT_FA_DIR/$FASTA"

echo File \"$FILE\"

#
# Read the PRODIGAL_CONF_FILE and use each line to launch PRODIGAL 
#
#if [ -e $PRODIGAL_CONF_FILE ]; then
   #while read PRODIGAL_DB_NAME ; do
        
        PRODIGAL_PROTEIN_TRANS="$PRODIGAL_OUT_DIR/$FASTA_BASE/$FASTA_BASE.fasta"
        PRODIGAL_NUCLEOTIDE_SEQ="$PRODIGAL_OUT_DIR/$FASTA_BASE/$FASTA_BASE.nuc"
        PRODIGAL_OUT="$PRODIGAL_OUT_DIR/$FASTA_BASE/$FASTA_BASE.out"
        PRODIGAL_SCORE="$PRODIGAL_OUT_DIR/$FASTA_BASE/$FASTA_BASE.score"
        PRODIGAL_SIXTY="$PRODIGAL_OUT_DIR/$FASTA_BASE/$FASTA_BASE.60"
        DIR=`dirname $PRODIGAL_OUT`

        if [[ ! -d $DIR ]]; then
            mkdir -p $DIR
        fi

        if [[ -e [$PRODIGAL_PROTEIN_TRANS || $PRODIGAL_NUCLEOTIDE_SEQ || $PRODIGAL_OUT || $PRODIGAL_SCORE || $PRODIGAL_SIXTY] ]]; then
            rm -rf $PRODIGAL_PROTEIN_TRANS $PRODIGAL_NUCLEOTIDE_SEQ $PRODIGAL_OUT $PRODIGAL_SCORE $PRODIGAL_SIXTY
        fi

        $PRODIGAL -a $PRODIGAL_PROTEIN_TRANS -d $PRODIGAL_NUCLEOTIDE_SEQ -i $FILE -o $PRODIGAL_OUT -s $PRODIGAL_SCORE -f $OUTPUT_FMT -p $PRODIGAL_PROCEDURE 
        
        $SCRIPT_DIR/filter_by_size.pl $PRODIGAL_PROTEIN_TRANS $PRODIGAL_SIXTY   

   #done < "$PRODIGAL_CONF_FILE"
#else 
#    echo "Cannot find PRODIGAL_CONF_FILE $PRODIGAL_CONF_FILE"
#fi

echo Finished `date`
