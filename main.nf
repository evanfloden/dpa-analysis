import groovy.text.*
import java.io.*

params.name = "dpa-non-dpa-full-pipeline-nf"

params.align_dpa_method = "CLUSTALO_DPA"
params.align_method = "CLUSTALO"
params.tree_method = "CLUSTALO_RND"

params.dataset="homfamClustalo"   //test, homfamClustalo
params.output_tree_folder= "tree_${params.tree_method}"

params.datasets_directory="/users/cn/egarriga/projects/00_dpa/dataset"

params.output_dir_tree = ("$baseDir/results/$params.output_tree_folder")
params.output_dir_aln = "$baseDir/results/${params.align_method}"

params.bucket="200"   

log.info "D P A / N O N - D P A - f u l l - p i p e l i n e  ~  version 0.1"
log.info "====================================="
log.info "name                            : ${params.name}"
log.info "input sequences (FA)            : ${params.datasets_directory}/${params.dataset}"
log.info "output (TREE)                   : ${params.output_dir_tree}"
log.info "output (ALN)                    : ${params.output_dir_aln}"
log.info "alignment method [CLUSTALO|MAFFT|UPP]		: ${params.align_method}"
log.info "tree method [CLUSTALO|MAFFT|CLUSTALO_RND|MAFFT_RND]    : ${params.tree_method}"
log.info "\n"

Channel
  .fromPath("${params.datasets_directory}/${params.dataset}/*.fa")
  .ifEmpty{ error "Missing data in Channel dataset_fa"}
  .map { tuple( it.name.tokenize('.')[0], it ) }
  .into{ dataset_fa }

Channel
  .fromPath("${params.datasets_directory}/${params.dataset}/*.fa.ref")
  .ifEmpty{ error "Missing data in Channel dataset_ref"}
  .map { tuple( it.name.tokenize('.')[0], it ) }
  .into{ dataset_ref ; dataset_ref2 }

/************************************
*
* Generate Tree for each sequence
*
*/
 process tree_ref{

 tag "${params.tree_method}/${id}"
 publishDir "${params.output_dir_tree}", pattern: '*.dnd', mode: 'copy', overwrite: true

 input:
 set id, file(ref)  from dataset_ref

 output:
 set id, file(ref), file('*.dnd') into set_tree_ref

 script:
 template "tree/generate_tree_ref_${params.tree_method}.sh"

}

process tree{

 tag "${params.tree_method}/${id}"
 publishDir "${params.output_dir_tree}", pattern:'*.dnd', mode: 'copy', overwrite: true

 input:
 set id, file(fa), file(ref)  from dataset_fa

 output:
 set id, file(fa), file('*.dnd')  into set_tree_fa ; set_tree_fa2

 script:
 template "tree/generate_tree_${params.tree_method}.sh"
}

/************************************
*
* Merge the data
*
*/
set_tree_fa.phase(set_tree_ref)
      //.view()                
    .map { tuple(it[0][0], it[0][1], it[1][1], it[0][2],it[1][2])}
    .into {dataset_tot}                           

/************************************
*
* Generate Alignments for each sequence
*
*/

process aln {
  tag "${params.align_method}/${id}"
  publishDir "${params.output_dir_aln}/${id}", pattern: '*aln.fa*' , mode: 'copy', overwrite: true

  input:
  set id, file(fa), file(ref), file(tree), file(ref_tree) from dataset_tot

  output:
  set id, file(fa), file(ref), file('*_aln.fa'), file('*_aln.fa.ref') into ref_alignments

  script:
  template "alignment/generate_alignment_${params.align_method}.sh"
}
/***********************************
*
* Prepare data for DPA
*
*/
Channel.from( "${params.bucket}".tokenize() )
     .into{ bucs }

bucs.combine(set_tree_fa2)
        //.view()
        .into { data_pairs }
/************************************
*
* Generate DPA Alignments for each sequence
* and bucket size
*
*/
process aln_dpa {
  tag "${params.align_dpa_method}/${buc}/${id}"
  publishDir "${params.output_dir_aln}/$buc/$id", mode: 'copy', overwrite: true

  input:
  set buc, id, file(fasta), file(tree)  from data_pairs

  output:
  set id, buc, file('aln.fa') into alignments

  script:
  """
  t_coffee -dpa -dpa_method ${params.align_dpa_method} -dpa_tree $tree -seq $fasta -outfile aln.fa  -dpa_nseq $buc -dpa_thread $task.cpus
  """

}

dataset_ref2.combine(alignments, by: 0)
//      .println()
        .into{ data_aln }

/************************************
*
* SCORE the alignments
*
*/
process score {
    tag "SCORE/${id}"

    publishDir "${params.output_dir_aln}/${id}", mode: 'move', overwrite: true

    input:
    set id, file(fa), file(ref), file(aln), file(ref_aln) from ref_alignments

    output:
    file("*.out")

    """
    t_coffee -other_pg aln_compare -al1 ${ref} -al2 ${ref_aln} -compare_mode sp | grep -v "seq1" |grep -v '*' | awk '{ print "SOP="\$4}' > ${id}_ref_score.out
    t_coffee -other_pg aln_compare -al1 ${ref} -al2 ${ref_aln} -compare_mode tc | grep -v "seq1" |grep -v '*' | awk '{ print "TC="\$4}' >> ${id}_ref_score.out
    t_coffee -other_pg aln_compare -al1 ${ref} -al2 ${ref_aln} -compare_mode column | grep -v "seq1" |grep -v '*' | awk '{ print "COL="\$4}' >> ${id}_ref_score.out

    t_coffee -other_pg aln_compare -al1 ${ref} -al2 ${aln} -compare_mode sp | grep -v "seq1" |grep -v '*' | awk '{ print "SOP="\$4}' > ${id}_score.out
    t_coffee -other_pg aln_compare -al1 ${ref} -al2 ${aln} -compare_mode tc | grep -v "seq1" |grep -v '*' | awk '{ print "TC="\$4}' >> ${id}_score.out
    t_coffee -other_pg aln_compare -al1 ${ref} -al2 ${aln} -compare_mode column | grep -v "seq1" |grep -v '*' | awk '{ print "COL="\$4}' >> ${id}_score.out

    """
}

workflow.onComplete {
    def subject = 'Full NF execution'
    def recipient = 'edgar.garriga@crg.eu'

    ['mail', '-s', subject, recipient].execute() << """

    Pipeline execution summary
    ---------------------------
    Completed at: ${workflow.complete}
    Duration    : ${workflow.duration}
    Success     : ${workflow.success}
    Command Line: ${workflow.commandLine}
    workDir     : ${workflow.workDir}
    exit status : ${workflow.exitStatus}
    error message : ${workflow.errorMessage}
    Error report: ${workflow.errorReport ?: '-'}
    """
}




