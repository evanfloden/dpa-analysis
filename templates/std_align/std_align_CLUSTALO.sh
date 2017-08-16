clustalo --infile=${seqs} \
         --guidetree-in=${guide_tree} \
         --outfmt=fa \
         -o ${id}.std.${align_method}.with.${tree_method}.tree.aln
