mafft-fftns --retree 1 --anysymbol --treeout ${seqs}
t_coffee -other_pg seq_reformat -in ${seqs}.tree -in2 ${seqs} -input newick -action +mafftnewick2newick > ${id}.${tree_method}.dnd

