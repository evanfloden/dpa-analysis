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
 * Evan Floden <evanfloden@gmail.com>
 * Paolo Di Tommaso <paolo.ditommaso@gmail.com>
 * Edgar Garriga
 * Cedric Notredame 
 */

/*
 * defaults parameter definitions
 */

// Name
params.name = "DPA_Analysis"

// input sequences to align [FASTA]
params.seqs = "$baseDir/tutorial/seqs/*.fa"

// input reference sequences aligned [Aligned FASTA]
params.refs = "$baseDir/tutorial/refs/*.ref"

// input guide tree(s) [NEWICK]
//trees = "$baseDir/tutorial/trees/*.dnd"
params.trees = false

// output directory [DIRECTORY]
params.output = "$baseDir/results"

// alignment method [CLUSTALO | MAFFT | UPP]
params.align_method = "CLUSTALO"

// tree method [CLUSTALO | MAFFT | RANDOM]
params.tree_method = "CLUSTALO"

// create dpa alignments [BOOL]
params.dpa_align = true

// use standard alingments [BOOL]
params.std_align = true

// bucket sizes for DPA [COMMA SEPARATED VALUES]
params.buckets = '50,100,200,500'


log.info """\
         D P A   A n a l y s i s  ~  version 0.1"
         ======================================="
         Name                                                  : ${params.name}
         Input sequences (FASTA)                               : ${params.seqs}
         Input references (Aligned FASTA)                      : ${params.refs}
         Input trees (NEWICK)                                  : ${params.trees}
         Output directory (DIRECTORY)                          : ${params.output}
         Alignment method [CLUSTALO|MAFFT|UPP]                 : ${params.align_method}
         Tree method [CLUSTALO|MAFFT|CLUSTALO_RND|MAFFT_RND]   : ${params.tree_method}
         Perform standard alignments                           : ${params.std_align}
         Perform double progressive alignments (DPA)           : ${params.dpa_align}
         Bucket Sizes for DPA                                  : ${params.buckets}
         """
         .stripIndent()


//
// EXPLICITLY STATE WHICH MODE WE ARE RUNNING IN BASED ON INPUT ARGUMENTS
// 
if( !params.seqs ) 
    error "Parameter `--seqs` is required, see README."

// Mode 1: Basic Alignment Mode
if ( !params.refs && !params.trees ) 
  log.info "Running in Mode 1: Basic Alignment\n"
  
// Mode 2: Reference Alignment Mode
else if ( params.refs && !params.trees ) 
  log.info "Running in Mode 2: Reference Alignment Mode\n"

// Mode 3: Custom Guide Tree Alignment Mode
else if ( !params.refs && params.trees ) 
  log.info "Running in Mode 3: Custom Guide Tree Alignment Mode\n"

// Mode 4: Reference Alignment Mode with Custom Guide Tree
else if ( params.refs && params.trees ) 
  log.info "Running in Mode 4: Reference Alignment Mode with Custom Guide Tree\n"

else  
    error "Error in determining running mode, see README."


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
    .combine( refs, by: 0 )
    .set { seqsAndRefs }

  Channel.empty().set { seqs3 }  // <-- THIS MAY NOT BE NEEDED -- NEEDS TO BE REVIEWED
}
else { 
    Channel.empty().into { refs2; seqsAndRefs }
}

// Channels for user provided trees [OPTIONAL]
if ( params.trees ) {
  Channel
    .fromPath(params.trees)
    .map { item -> [ item.baseName, "USER_PROVIDED", item] }
    .set { treesProvided }
}
else {
    Channel.empty().set { treesProvided }
}


//
// IF REFERENCE ALIGNMENT IS PRESENT THEN COMBINE SEQS INTO RANDOM ORDERED FASTA
//

process combine_seqs {

  tag "${id}"
  publishDir "${params.output}/sequences", mode: 'copy', overwrite: true

  input:
  set val(id), \
      file(sequences), \
      file(references) \
      from seqsAndRefs

  output:
  set val(id), \
      file("seqsFinal.fa") \
      into seqsAndRefsComplete

  script:
    """
    # CREATE A FASTA FILE CONTAINING ALL SEQUENCES (SEQS + REFS)
    t_coffee -other_pg seq_reformat -in ${references} -output fasta_seq -out refs.tmp.fa
    t_coffee -other_pg seq_reformat -in ${sequences} -output fasta_seq -out seqs.tmp.fa

    cat refs.tmp.fa > completeSeqs.fa
    cat seqs.tmp.fa >> completeSeqs.fa

    # SHUFFLE ORDER OF SEQUENCES
    t_coffee -other_pg seq_reformat -in completeSeqs.fa -output fasta_seq -out shuffledCompleteSequences.fa -action +reorder random
 
    sed '/^\\s*\$/d' shuffledCompleteSequences.fa > seqsFinal.fa

    """
}


seqsAndRefsComplete
  .mix ( seqs3 )
  .into { seqsForAlign; seqsForTrees }


/*
 * GENERATE GUIDE TREES USING "--tree_method"
 *
 * NOTE: THIS IS ONLY IF GUIDE TREES ARE NOT PROVIDED BY THE USER
 * BY USING THE `--trees` PARAMETER
 */
process guide_trees {
   tag "${params.tree_method}/${id}"
   publishDir "${params.output}/guide_trees", mode: 'copy', overwrite: true

   input:
     set val(id), \
         file(seqs) \
         from seqsForTrees

   output:
     set val(id), \
         val({params.tree_method}), \
         file("${id}.${params.tree_method}.dnd") \
         into treesGenerated

   when:
     !params.trees

   script:
     template "tree/generate_tree_${params.tree_method}.sh"
}


treesGenerated
  .mix ( treesProvided )
  .combine ( seqsForAlign, by:0 )
  .into { seqsAndTreesSTD; seqsAndTreesDPA }


process std_alignment {
  
    tag "${id} - ${params.align_method} - STD - NA"
    publishDir "${params.output}/alignments", mode: 'copy', overwrite: true

    input:
      set val(id), \
          val(tree_method), \
          file(guide_tree), \
          file(seqs) \
          from seqsAndTreesSTD

    when:
      params.std_align

    output:
      set val(id), \
      val("${params.align_method}"), \
      val(tree_method), val("std_align"), \
      val("NA"), file("${id}.${params.align_method}.std.aln") \
      into std_alignments

     script:
       template "align/std_align_${params.align_method}.sh"
}


process dpa_alignment {

    tag "${id} - ${params.align_method} - DPA - ${bucket_size}"
    publishDir "${params.output}/alignments", mode: 'copy', overwrite: true

    input:
      set val(id), \
          val(tree_method), \
          file(guide_tree), \
          file(seqs) \
          from seqsAndTreesDPA

       each bucket_size from params.buckets.tokenize(',')

    output:
      set val(id), \
      val("${params.align_method}"), \
      val(tree_method), \
      val("dpa_align"), \
      val(bucket_size), \
      file("${id}.${params.align_method}.dpa.aln") \
      into dpa_alignments

    when:
      params.dpa_align

    script:
       template "align/dpa_align_${params.align_method}.sh"
}


//
// Create a channel that combines references and alignments to be evaluated.
//

std_alignments
  .mix ( dpa_alignments )
  .set { all_alignments }

refs2
  .cross ( all_alignments )
  .map { it -> [it[0][0], it[1][1], it[1][2], it[1][3], it[1][4], it[1][5], it[0][1]] }
  .set { toEvaluate }


process evaluate {

    tag "${id} - ${params.tree_method} - ${params.align_method} - ${align_type} - ${bucket_size}"

    input:
      set val(id), \
          val(align_method), \
          val(tree_method), \
          val(align_type), \
          val(bucket_size), \
          file(test_alignment), \
          file(ref_alignment) \
          from toEvaluate

    output:
      set val(id), val(tree_method), \
          val(align_method), val(align_type), \
          val(bucket_size), file("score.sp.tsv") \
          into spScores

      set val(id), val(tree_method), \
          val(align_method), val(align_type), \
          val(bucket_size), file("score.tc.tsv") \
          into tcScores

      set val(id), val(tree_method), \
          val(align_method), val(align_type), \
          val(bucket_size), file("score.col.tsv") \
          into colScores

    when:
      params.refs

     script:
     """
       t_coffee -other_pg aln_compare \
             -al1 ${ref_alignment} \
             -al2 ${test_alignment} \
            -compare_mode sp \
            | grep -v "seq1" |grep -v '*' | awk '{ print \$4}' ORS="\t" \
            >> "score.sp.tsv"

       t_coffee -other_pg aln_compare \
             -al1 ${ref_alignment} \
             -al2 ${test_alignment} \
            -compare_mode tc \
            | grep -v "seq1" |grep -v '*' | awk '{ print \$4}' ORS="\t" \
            >> "score.tc.tsv"

       t_coffee -other_pg aln_compare \
             -al1 ${ref_alignment} \
             -al2 ${test_alignment} \
            -compare_mode column \
            | grep -v "seq1" |grep -v '*' | awk '{ print \$4}' ORS="\t" \
            >> "score.col.tsv"
    """
}
 

spScores
    .collectFile(name:"spScores.${workflow.runName}.csv", sort:{ it[0] }, newLine:true, storeDir: "$params.output/scores" ) {
        it[0]+"\t"+it[1]+"\t"+it[2]+"\t"+it[3]+"\t"+it[4]+"\t"+it[5].text }

tcScores
    .collectFile(name:"tcScores.${workflow.runName}.csv", sort:{ it[0] }, newLine:true, storeDir: "$params.output/scores" ) {
        it[0]+"\t"+it[1]+"\t"+it[2]+"\t"+it[3]+"\t"+it[4]+"\t"+it[5].text }

colScores
    .collectFile(name:"colScores.${workflow.runName}.csv", sort:{ it[0] }, newLine:true, storeDir: "$params.output/scores" ) {
        it[0]+"\t"+it[1]+"\t"+it[2]+"\t"+it[3]+"\t"+it[4]+"\t"+it[5].text }

