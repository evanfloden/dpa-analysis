clustalo -i ${seqs} --guidetree-out ${id}.${params.tree_method}.dnd.tmp
python ${baseDir}/bin/randomTree.py ${id}.${params.tree_method}.dnd.tmp
sed -e 's/-0.[0-9]\\+//g' ${id}.${params.tree_method}.dnd.tmp.rnd > ${id}.${params.tree_method}.dnd
