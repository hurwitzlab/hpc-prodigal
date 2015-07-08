#$ -S /bin/bash

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
OPTIONS="-g 1 -n 4 -d 0 -T 24 -M 45000"

cd "$CDHIT2D_DIR"

CDHIT2D_FILES=`head -n +${PBS_ARRAY_INDEX} $CDHIT2D_FILES_LIST | tail -n 1`
CDHIT2D_FILES_BASE=$(echo "$CDHIT2D_FILES" | cut -d '.' -f1)

FILE="$CDHIT2D_DIR/$CDHIT2D_FILES"

echo File \"$FILE\"

export OUTPUT_FILE="$CDHIT_DIR/$CDHIT2D_FILES_BASE"

#
# Read the PRODIGAL_CONF_FILE and use each line to launch PRODIGAL
#
#if [ -e $PRODIGAL_CONF_FILE ]; then
   #while read PRODIGAL_DB_NAME ; do

        DIR=`dirname $CDHIT_DIR`

        if [[ ! -d $DIR ]]; then
            mkdir -p $DIR
        fi

        if [ -e $OUTPUT_FILE ]; then
            rm -rf $OUTPUT_FILE
        fi

        $CDHIT -i $FILE -o $OUTPUT_FILE -c $IDEN -aS $COV $OPTIONS

   #done < "$PRODIGAL_CONF_FILE"
#else
#    echo "Cannot find PRODIGAL_CONF_FILE $PRODIGAL_CONF_FILE"
#fi

# get 20+ id clusters and cluster to count FILE
OUTCL="$CDHIT_DIR/$CDHIT2D_FILES_BASE.clstr"
OUTFILE="$CDHIT_DIR/$CDHIT2D_FILES_BASE"
$SCRIPT_DIR/get_20+_clusters.pl $OUTCL $OUTFILE

# create a list of ids that belong to the 20+ member clusters
$SCRIPT_DIR/create_id_to_clst.pl $OUTCL $OUTFILE

# create a fasta FILE with sequences from 20+ member clusters
LIST="$OUTFILE.clstr2id"
OUTFA="$OUTFILE.20+.fa"
$SCRIPT_DIR/get_list_from_fa.pl $OUTFILE $LIST $OUTFA

echo Finished `date`
