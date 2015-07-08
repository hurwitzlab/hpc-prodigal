source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR"

if [[ ! -d "$CDHIT_DIR" ]]; then
    mkdir -p "$CDHIT_DIR"
fi

cd "$CDHIT2D_DIR"

export CDHIT2D_FILES_LIST="cdhit2d-files"
find . -type f -name \*.cdhit2d | sed "s/^\.\///" > $CDHIT2D_FILES_LIST


NUM_FILES=`wc -l $CDHIT2D_FILES_LIST | cut -f 1 -d ' '`

echo Found \"$NUM_FILES\" files in \"$CDHIT2D_DIR\"

if [ $NUM_FILES -gt 0 ]; then
    JOB_ID=`qsub -v SCRIPT_DIR,CDHIT,CDHIT_DIR,CDHIT2D_FILES_LIST,CDHIT2D_DIR -N cdhit -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES $SCRIPT_DIR/run_selfcluster.sh`

    if [ "${JOB_ID}x" != "x" ]; then
        echo Job: \"$JOB_ID\"
    else
        echo Problem submitting job.
    fi
else
    echo Nothing to do.
fi
