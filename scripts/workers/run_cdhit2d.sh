#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard 
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=12:mem=23gb:pcmem=2gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00

echo Started `date`
echo Host `hostname`

# cdhit2d parameters
IDEN="0.6"
COV="0.8"
OPTIONS="-g 1 -n 4 -d 0 -T 24 -M 0"

cd "$PRODIGAL_OUT_DIR"

FASTA=`head -n +${PBS_ARRAY_INDEX} $PRODIGAL_FILES_LIST | tail -n 1`
BASE_FILE=`basename $FASTA`
FASTA_BASE=$(echo "$BASE_FILE" | cut -d'.' -f1)

FILE="$PRODIGAL_OUT_DIR/$FASTA"

echo File \"$FILE\"

export INPUT2="/rsgrps/bhurwitz/hurwitzlab/data/reference/gos/GOS.fa"
export OUTPUT_FILE="$CDHIT2D_DIR/$FASTA_BASE.cdhit2d"

#
# Read the PRODIGAL_CONF_FILE and use each line to launch PRODIGAL
#
#if [ -e $PRODIGAL_CONF_FILE ]; then
   #while read PRODIGAL_DB_NAME ; do

        DIR=`dirname $CDHIT2D_DIR`

        if [[ ! -d $DIR ]]; then
            mkdir -p $DIR
        fi

        if [ -e $OUTPUT_FILE ]; then
            rm -rf $OUTPUT_FILE
        fi

        $CDHIT2D -i $FILE -i2 $INPUT2 -o $OUTPUT_FILE -c $IDEN -aS $COV $OPTIONS

   #done < "$PRODIGAL_CONF_FILE"
#else
#    echo "Cannot find PRODIGAL_CONF_FILE $PRODIGAL_CONF_FILE"
#fi

echo Finished `date`

