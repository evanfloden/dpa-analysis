t_coffee -other_pg seq_reformat -in ${seqs} -action +seq2dnd mafftdnd -output newick >> ${id}.${params.tree_method}.dnd.tmp 
python ${baseDir}/bin/randomTree.py ${id}.${params.tree_method}.dnd.tmp
mv ${id}.${params.tree_method}.dnd.tmp.rnd ${id}.${params.tree_method}.dnd
