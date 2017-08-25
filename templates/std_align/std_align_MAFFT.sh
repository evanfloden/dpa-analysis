t_coffee -other_pg seq_reformat -in ${guide_tree} -input newick -in2 ${seqs} -input2 fasta_seq -action +newick2mafftnewick >> ${id}.mafftnewick
mafft --anysymbol --treein ${id}.mafftnewick ${seqs} > ${id}.std.${align_method}.with.${tree_method}.tree.aln
