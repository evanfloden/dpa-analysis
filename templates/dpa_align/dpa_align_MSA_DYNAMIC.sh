#! /bin/sh

$baseDir/bin/msa_dynamic ${seqs} ${bucket_size}

a=\$?

mv out.aln ${id}.dpa_\${a}.${align_method}.with.${tree_method}.tree.aln

echo \${a} >>file.txt

