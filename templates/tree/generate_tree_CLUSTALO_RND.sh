clustalo -i $fa --guidetree-out ${id}.co.dnd --force 1>/dev/null 2>&1
python ${baseDir}/bin/randomTree.py ${id}.co.dnd

rm ${id}.co.dnd
