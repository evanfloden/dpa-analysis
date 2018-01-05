clustalo -i ${seqs} --guidetree-out ${id}.CLUSTALO.dnd

t_coffee -other_pg seq_reformat -in ${id}.CLUSTALO.dnd -action +newick_randomize 1 >> ${id}.${tree_method}.dnd

rm ${id}.CLUSTALO.dnd

