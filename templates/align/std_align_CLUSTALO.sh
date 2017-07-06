clustalo --infile=${seqs} \
         --guidetree-in=${guide_tree} \
         --outfmt=fa \
         -o ${id}.${params.align_method}.std.aln
