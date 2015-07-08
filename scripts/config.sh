export CWD=$PWD
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export FASTQ_DIR="/rsgrps/bhurwitz/ajacob/prodigal/data/fastq"
#export FASTA_DIR="/rsgrps/bhurwitz/ajacob/prodigal/data/fasta"
export FASTA_DIR="/rsgrps/bhurwitz/ajacob/hpc-prodigal/mouse_data"
#export SPLIT_FA_DIR="/rsgrps/bhurwitz/ajacob/prodigal/data/fasta"
#export SPLIT_FA_DIR="/rsgrps/bhurwitz/ajacob/hpc-prodigal/mouse_data"
export SPLIT_FA_DIR="/rsgrps/bhurwitz/ajacob/hpc-prodigal/fasta-split"
export PRODIGAL_OUT_DIR="/rsgrps/bhurwitz/ajacob/hpc-prodigal/prodigal-out"
export CDHIT2D_DIR="/rsgrps/bhurwitz/ajacob/hpc-prodigal/cdhit2d-dir"
export CDHIT_DIR="/rsgrps/bhurwitz/ajacob/hpc-prodigal/cdhit-dir"
export SCRIPT_DIR="$CWD/workers"
export FA_SPLIT_FILE_SIZE=150000000 # in KB
#export PRODIGAL_CONF_FILE="/rsgrps/bhurwitz/ajacob/hpc-prodigal/prodigaldbs"
export PRODIGAL="/rsgrps/bhurwitz/hurwitzlab/bin/prodigal"
export CDHIT2D="/rsgrps/bhurwitz/hurwitzlab/bin/cdhit/cd-hit-2d"
export CDHIT="/rsgrps/bhurwitz/hurwitzlab/bin/cdhit/cd-hit"
export JOBS=100

function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}
