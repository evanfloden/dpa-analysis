ruby ${baseDir}/bin/newick2mafft.rb ${guide_tree} > tree.mafft
mafft-sparsecore.rb -s 42 -p 100 --treein tree.mafft -i ${seqs} > ${id}.${params.align_method}.std.aln

