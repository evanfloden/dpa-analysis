replace_U.pl ${seqs}

run_upp.py -s ${seqs} \
           -m amino \
           -x 1 \
           -o ${id}.default.${align_method}

mv ${id}.default.${align_method}_alignment.fasta ${id}.default.${align_method}.aln
