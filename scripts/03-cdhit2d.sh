source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR"

if [[ ! -d "$CDHIT2D_DIR" ]]; then
    mkdir -p "$CDHIT2D_DIR"
fi

cd "$PRODIGAL_OUT_DIR"

export PRODIGAL_FILES_LIST="prodigal-files"
find . -type f -name \*.fasta | sed "s/^\.\///" > $PRODIGAL_FILES_LIST


NUM_FILES=`wc -l $PRODIGAL_FILES_LIST | cut -f 1 -d ' '`

echo Found \"$NUM_FILES\" files in \"$PRODIGAL_OUT_DIR\"

if [ $NUM_FILES -gt 0 ]; then
    JOB_ID=`qsub -v SCRIPT_DIR,CDHIT2D,PRODIGAL_OUT_DIR,PRODIGAL_FILES_LIST,CDHIT2D_DIR -N cdhit2d -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES $SCRIPT_DIR/run_cdhit2d.sh`

    if [ "${JOB_ID}x" != "x" ]; then
        echo Job: \"$JOB_ID\"
    else
        echo Problem submitting job.
    fi
else
    echo Nothing to do.
fi
