# Create parttree guidetree named ${seqs}.tree 
mafft --parttree --treeout ${seqs}

# Create a map of Numbers to SeqIDs
grep '^>' ${seqs} | sed 's/>//' | awk '{ print ((NR-1))+1, \$0 }' > map.data

# Split each number in tree onto a newline
sed 's/\\([,()]\\)/\\1\\n/g' ${seqs}.tree > ${seqs}.tree.split

sed 's/\\([0-9]*\\)\\([),]\\)/\\1\\n\\2/g' ${seqs}.tree.split > ${seqs}.tree.split2

# Replace each number with the correct ID
awk -f ${baseDir}/bin/mapReplace.awk map.data ${seqs}.tree.split2 > ${seqs}.namedTree

# Remove whitespace
sed ':a;\$!{N;s/\\n//;ba;}' ${seqs}.namedTree > ${id}.${params.tree_method}.dnd 
