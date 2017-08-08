t_coffee -dpa -dpa_method mafft_msa \
         -dpa_tree ${guide_tree} \
         -seq ${seqs} \
         -dpa_nseq ${bucket_size} \
         -outfile ${id}.${align_method}.dpa.aln
