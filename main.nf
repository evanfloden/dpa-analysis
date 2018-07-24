/*
 * Copyright (c) 2018, Centre for Genomic Regulation (CRG) and the authors.
 *
 *   This file is part of 'regressive-msa-analysis'.
 *
 *   regressive-msa--analysis is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   regressive-msa-analysis is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with regressive-msa-analysis.  If not, see <http://www.gnu.org/licenses/>.
 */

/* 
 * Main regressive-msa-analysis pipeline script
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

// input sequences to align in fasta format
params.seqs = "$baseDir/data/combined_seqs/*.fa"

// input reference sequences aligned in 
params.refs = "$baseDir/data/refs/*.ref"

// input guide trees in Newick format. Or `false` to generate trees
//params.trees = "$baseDir/data/trees/*.CLUSTALO.dnd"
params.trees = false

// which alignment methods to run
params.align_method = "CLUSTALO"  //,MAFFT-FFTNS1,MAFFT-GINSI,PROBCONS,UPP"

// which tree methods to run if `trees` == `false`
params.tree_method = "CLUSTALO"  //,MAFFT-FFTNS1,MAFFT_PARTTREE"

// generate regressive alignments ?
params.regressive_align = true

// create standard alignments ?
params.standard_align = true

// create default alignments ? 
params.default_align = true

// evaluate alignments ?
params.evaluate = true

// bucket sizes for regressive algorithm
params.buckets= '1000'

// output directory
params.output = "$baseDir/results2" // output directory 


log.info """\
         R E G R E S S I V E   M S A   A n a l y s i s  ~  version 0.1"
         ======================================="
         Input sequences (FASTA)                        : ${params.seqs}
         Input references (Aligned FASTA)               : ${params.refs}
         Input trees (NEWICK)                           : ${params.trees}
         Output directory (DIRECTORY)                   : ${params.output}
         Alignment methods                              : ${params.align_method}
         Tree methods                                   : ${params.tree_method}
         Generate default alignments                    : ${params.default_align}
         Generate standard alignments                   : ${params.standard_align}
         Generate regressive alignments (DPA)           : ${params.regressive_align}
         Bucket Sizes for regressive alignments         : ${params.buckets}
         Perform evaluation? Requires reference         : ${params.evaluate}
         Output directory (DIRECTORY)                   : ${params.output}
         """
         .stripIndent()


// Channels containing sequences
if ( params.seqs ) {
  Channel
  .fromPath(params.seqs)
  .map { item -> [ item.baseName, item] }
  .into { seqs; seqs2; seqs3 }
}

// Channels containing reference alignments for evaluation [OPTIONAL]
if( params.refs ) {
  Channel
    .fromPath(params.refs)
    .map { item -> [ item.baseName, item] }
    .set { refs }
}

// Channels for user provided trees or empty channel if trees are to be generated [OPTIONAL]
if ( params.trees ) {
  Channel
    .fromPath(params.trees)
    .map { item -> [ item.baseName.tokenize('.')[0], item.baseName.tokenize('.')[1], item] }
    .set { trees }
}
else { 
  Channel
    .empty()
    .set { trees }
}

tree_methods = params.tree_method
align_methods = params.align_method


/*
 * GENERATE GUIDE TREES USING MEHTODS DEFINED WITH "--tree_method"
 *
 * NOTE: THIS IS ONLY IF GUIDE TREES ARE NOT PROVIDED BY THE USER
 * BY USING THE `--trees` PARAMETER
 */

process guide_trees {

    tag "${id}.${tree_method}"
    publishDir "${params.output}/guide_trees", mode: 'copy', overwrite: true
   
    input:

     set val(id), \
         file(seqs) \
         from seqs
     each tree_method from tree_methods.tokenize(',') 

   output:
     set val(id), \
       val(tree_method), \
       file("${id}.${tree_method}.dnd") \
       into treesGenerated

   when:
     !params.trees

   script:
     template "tree/generate_tree_${tree_method}.sh"
}


treesGenerated
  .mix ( trees )
  .combine ( seqs2, by:0 )
  .into { seqsAndTreesForStandardAlignment; seqsAndTreesForRegressiveAlignment }


process standard_alignment {
  
    tag "${id}.${align_method}.STD.NA.${tree_method}"
    publishDir "${params.output}/alignments", mode: 'copy', overwrite: true
    
    input:
      set val(id), \
        val(tree_method), \
        file(guide_tree), \
        file(seqs) \
        from seqsAndTreesForStandardAlignment

      each align_method from align_methods.tokenize(',') 

    when:
      params.standard_align

    output:
      set val(id), \
      val("${align_method}"), \
      val(tree_method), val("std_align"), \
      val("NA"), file("${id}.std.${align_method}.with.${tree_method}.tree.aln") \
      into standard_alignments

     script:
       template "std_align/std_align_${align_method}.sh"
}


process regressive_alignment {

    tag "${id}.${align_method}.DPA.${bucket_size}.${tree_method}"
    publishDir "${params.output}/alignments", mode: 'copy', overwrite: true

    input:
      set val(id), \
        val(tree_method), \
        file(guide_tree), \
        file(seqs) \
        from seqsAndTreesForRegressiveAlignment

      each bucket_size from params.buckets.tokenize(',')
       
      each align_method from align_methods.tokenize(',')   

    output:
      set val(id), \
        val("${align_method}"), \
        val(tree_method), \
        val("dpa_align"), \
        val(bucket_size), \
        file("*.aln") \
        into regressive_alignments

    when:
      params.regressive_align

    script:
       template "dpa_align/dpa_align_${align_method}.sh"
}

process default_alignment {

    tag "${id}.${align_method}.DEFAULT.NA.${align_method}"
    publishDir "${params.output}/alignments", mode: 'copy', overwrite: true

    input:
      set val(id), file(seqs) from seqs3
      each align_method from align_methods.tokenize(',') 

    when:
      params.default_align

    output:
      set val(id), \
      val("${align_method}"), \
      val("DEFAULT"), val("default_align"), \
      val("NA"), file("${id}.default.${align_method}.aln") \
      into default_alignments

     script:
       template "default_align/default_align_${align_method}.sh"
}

// Create a channel that combines references and alignments to be evaluated
standard_alignments
  .mix ( regressive_alignments )
  .mix ( default_alignments )
  .set { all_alignments }

refs
  .cross ( all_alignments )
  .map { it -> [it[0][0], it[1][1], it[1][2], it[1][3], it[1][4], it[1][5], it[0][1]] }
  .set { toEvaluate }


process evaluate {
    
    tag "${id}.${align_method}.${tree_method}.${align_type}.${bucket_size}"
    publishDir "${params.output}/individual_scores", mode: 'copy', overwrite: true

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
      set val(id), \
          val(tree_method), \
          val(align_method), \
          val(align_type), \
          val(bucket_size), \
          file("*.sp"), \
          file("*.tc"), \
          file("*.col") \
          into scores

    when:
      params.evaluate

     script:
     """
       ## Sum-of-Pairs Score ##
       t_coffee -other_pg aln_compare \
             -al1 ${ref_alignment} \
             -al2 ${test_alignment} \
            -compare_mode sp \
            | grep -v "seq1" | grep -v '*' | \
            awk '{ print \$4}' ORS="\t" \
            > "${id}.${align_type}.${bucket_size}.${align_method}.${tree_method}.sp"
       
       ## Total Column Score ##	
       t_coffee -other_pg aln_compare \
             -al1 ${ref_alignment} \
             -al2 ${test_alignment} \
            -compare_mode tc \
            | grep -v "seq1" | grep -v '*' | \
            awk '{ print \$4}' ORS="\t" \
            > "${id}.${align_type}.${bucket_size}.${align_method}.${tree_method}.tc"

       ## Column Score ##
       t_coffee -other_pg aln_compare \
             -al1 ${ref_alignment} \
             -al2 ${test_alignment} \
            -compare_mode column \
            | grep -v "seq1" | grep -v '*' | \
              awk '{ print \$4}' ORS="\t" \
            > "${id}.${align_type}.${bucket_size}.${align_method}.${tree_method}.col"

    """
}

scores
    .collectFile(name:"scores.${workflow.runName}.csv", newLine:true, storeDir: "$params.output/scores" ) {
      it[0]+"\t"+it[1]+"\t"+it[2]+"\t"+it[3]+"\t"+it[4]+"\t"+it[5].text+"\t"+it[6].text+"\t"+it[7].text
    }

workflow.onComplete {
  println "Execution status: ${ workflow.success ? 'OK' : 'failed' } runName: ${workflow.runName}"
}
