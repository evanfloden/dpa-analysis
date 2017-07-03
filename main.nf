/*
 * Copyright (c) 2017, Centre for Genomic Regulation (CRG) and the authors.
 *
 *   This file is part of 'dpa-analysis'.
 *
 *   dpa-analysis is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   dpa-analysis is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with dpa-analysis.  If not, see <http://www.gnu.org/licenses/>.
 */

/* 
 * Main dpa-analysis pipeline script
 *
 * @authors
 * Paolo Di Tommaso <paolo.ditommaso@gmail.com>
 * Evan Floden <evanfloden@gmail.com>
 * Edgar Garriga
 * Cedric Notredame 
 */

log.info "D P A   A n a l y s i s  ~  version 0.1"
log.info "====================================="
log.info "Name                                  : ${params.name}"
log.info "Input sequences (FASTA)               : ${params.seqs}"
log.info "Input references (Aligned FASTA)      : ${params.refs}"
log.info "Input trees (NEWICK)                  : ${params.trees}"
log.info "Output directory (DIRECTORY)          : ${params.output}"
log.info "Alignment method [CLUSTALO|MAFFT|UPP] : ${params.align_method}"
log.info "Tree method [CLUSTALO|MAFFT|RANDOM]   : ${params.tree_method}"
log.info "Use double progressive alignment      : ${params.dpa_align}"
log.info "\n"


// Channels for sequences [REQUIRED]
Channel
  .fromPath(params.seqs)
  .ifEmpty{ error "No files found in ${params.seqs}"}
  .map { item -> [ item.baseName, item] }
  .into { seqs; seqs2; seqs3  }

// Channels for reference alignments [OPTIONAL]
if( params.refs ) {
  Channel
    .fromPath(params.refs)
    .map { item -> [ item.baseName, item] }
    .into { refs; refs2 }

  seqs2
    .combine( refs, by: 0)
    .view()
    .into { seqsAndRefs; seqsAndRefs2}
}

// Channels for trees [OPTIONAL]
if (params.trees) {
  Channel
    .fromPath(params.trees)
    .map { item -> [ item.baseName, item] }
    .into { trees; trees2 }
  seqs3
    .combine( trees2, by: 0)
    .set { seqsAndTrees }
}


// IF REFERENCE ALIGNMENT IS PRESENT THEN COMBINE SEQS INTO RANDOM ORDERED FASTA
if( params.refs ) {
  process combine_seqs {
    tag "${id}"
 
    input:
    set val(id), file(sequences), file(references) from seqsAndRefs2

    output:
    set val(id), file("shuffledCompleteSequences.fa") into sequences

    script:
    """
    # CREATE HEADERS FILE WITH EACH SEQUENCE ID IN RANDOM ORDER
    grep '^>' ${sequences} > headers.txt
    grep '^>' ${references} >> headers.txt
    grep '^>' headers.txt | sort -R >> random_headers.txt

    # CREATE FASTA FILE CONTAINING ALL SEQUENCES
    esl-reformat --informat afa fasta ${references} > ref_seqs.fa
    cat ref_seqs.fa > completeSeqs.fa
    cat ${sequences} >> completeSeqs.fa

    # USE RANDOM HEADERS TO CREATE RANDOM ORDERED FASTA
    faSomeRecords completeSeqs.fa random_headers.txt shufflesCompleteSequences.fa
    """
  }
}
if (! params.refs ) {
  seqs2
    .set{sequences}
}



// IF GUIDE TREES ARE NOT PRESENT, GENERATE GUIDE TREES USING TREE METHOD
if (! params.trees ) {
  process guide_trees {                       

     tag "${params.tree_method}/${id}"
     publishDir "${params.output/guide_trees}", mode: 'copy', overwrite: true

     input:
       set val(id), file(sequences) from sequences

     output:
       set val(id), file("${id}.nwk") into guide_trees

     script:
       template "trees/generate_tree_${params.tree_method}.sh"
  }
}        



