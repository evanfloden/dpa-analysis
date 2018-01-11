t_coffee -other_pg seq_reformat -in ${seqs} -action +seq2dnd parttree -output newick >> ${id}.MAFFT_PARTTREE.dnd

t_coffee -other_pg seq_reformat -in ${id}.MAFFT_PARTTREE.dnd -action +newick_randomize 1 >> ${id}.${tree_method}.dnd

rm ${id}.MAFFT_PARTTREE.dnd

