cat ${seqs} | awk '/^>/ { if(i>0) printf("/\\n"); i++; printf("%s /\\t",\$0); next;} {printf("%s",\$0);} END { printf("/\\n");}' | shuf | awk '{printf("%s /\\n %s /\\n",\$1,\$2)}' >> tmp.fa

clustalo -i tmp.fa --guidetree-out ${id}.${params.tree_method}.dnd
