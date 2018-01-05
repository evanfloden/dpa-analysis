t_coffee -other_pg seq_reformat -in ${seqs} -action +seq2dnd mafftdnd -output newick >> ${id}.MAFFT.dnd 

t_coffee -other_pg seq_reformat -in ${id}.MAFFT.dnd -action +newick_randomize 1 >> ${id}.${tree_method}.dnd

rm ${id}.MAFFT.dnd

