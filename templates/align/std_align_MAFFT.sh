grep '^>' ${seqs} | sed 's/>//' | awk '{ print \$0, ((NR-1))+1 }' > map.data
awk -f ${baseDir}/bin/mapReplace.awk map.data ${guide_tree} > numberedTree.nwk
ruby ${baseDir}/bin/newick2mafft.rb numberedTree.nwk > tree.mafft
mafft --treein tree.mafft ${seqs} > ${id}.${params.align_method}.std.aln

