t_coffee -dpa -dpa_method msaprobs_msa \
         -dpa_tree ${guide_tree} \
         -seq ${seqs} \
         -dpa_nseq 200 \
         -outfile ${id}.${params.align_method}.dpa.aln
