t_coffee -other_pg seq_reformat -in ${guide_tree} -in2 ${seqs} -action +newick2mafftnewick > -out ${id}.mafftnewick
mafft --anysymbol --treein ${id}.maffttnewick ${seqs} > ${id}.std.${align_method}.with.${tree_method}.tree.aln
