t_coffee -dpa -dpa_method mafftginsi_msa \
         -dpa_tree blength \
         -seq ${seqs} \
         -dpa_nseq ${bucket_size} \
         -outfile ${id}.dpa_${bucket_size}.${align_method}.with.blength.tree.aln
