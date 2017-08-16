export CACHE_4_TCOFFEE=/users/cn/efloden/temp/tcoffee/cache
export LOCKDIR_4_TCOFFEE=/users/cn/efloden/temp/tcoffee/lock
export TMP_4_TCOFFEE=/users/cn/efloden/temp/tcoffee/tcf
export DIR_4_TCOFFEE=//users/cn/efloden/temp/tcoffee/dir

t_coffee -dpa -dpa_method probcons_msa \
         -dpa_tree ${guide_tree} \
         -seq ${seqs} \
         -dpa_nseq ${bucket_size} \
         -outfile ${id}.dpa_${bucket_size}.${align_method}.with.${tree_method}.tree.aln
