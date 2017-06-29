clustalo -i $ref --guidetree-out ${id}.co.ref.dnd --force 1>/dev/null 2>&1
python ${baseDir}/bin/randomTree_ref.py ${id}.co.ref.dnd

rm ${id}.co.ref.dnd
