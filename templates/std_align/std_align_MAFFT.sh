t_coffee -other_pg seq_reformat -in ${guide_tree} -input newick -in2 ${seqs} -input2 fasta_seq -action +newick2mafftnewick >> ${id}.mafftnewick

newick2mafft.rb 1.0 ${id}.mafftnewick > ${id}.mafftbinary

/mafft/bin/mafft --anysymbol --treein ${id}.mafftbinary ${seqs} > ${id}.std.${align_method}.with.${tree_method}.tree.aln
