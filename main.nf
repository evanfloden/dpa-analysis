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
log.info "Use double progressive alignment      : ${params.dpa}"
log.info "\n"

Channel
  .fromPath("params.seqs")
  .ifEmpty{ error "No files found in ${params.seqs}"}
  .map { item -> [ item.baseName, item] }
  .into{ sequences }

Channel
  .fromPath("params.refs")
  .ifEmpty{ error "No files found in ${params.refs}"}
  .map { item -> [ item.baseName, item] }
  .into{ references }

Channel
  .fromPath("params.trees")
 // .ifEmpty{ error "No files found in ${params.trees}"}
  .map { item -> [ item.baseName, item] }
  .into{ trees }

sequences
  .groupTuple(references)
  .map { item -> [ item[0][0], item[0][1], item[1][1] ]}
  .groupTuple( trees )
  .map { item -> [ item[0][0], item[0][1], item[0][2], item[1][1] ]}
  .view ()
  .set { datasets } 
   



