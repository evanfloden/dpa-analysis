# dpa-analysis


### Quick Start


### Running Modes

#### Basic Alignment Mode

Run basic multiple sequence alignment procedure with/without DPA.

*inputs:* 

* sequence(s) files (FASTA) using `--seqs` argument

*outputs:*

* multiple sequence alignments (Aligned FASTSA) 
* guide tree(s) used for the alignment

#### Reference Alignment Mode

Run basic multiple sequence alignment procedure with/without DPA and score alignment against the reference alignment.

*inputs:*

* sequence file(s) (FASTA) using `--seqs` argument
* reference alignment file(s) using `--refs` argument

*outputs:*

* multiple sequence alignments (Aligned FASTSA)
* tab seperated value file of alignments scored for SoP, Column and Total Column

#### Custom Guide Tree Alignment Mode

Run basic multiple sequence alignment procedure with/without DPA with user provided guide trees in Newick format.

*inputs:*

* sequence file(s) (FASTA) using `--seqs` argument
* guide tree file(s) (Newick) using `--trees` argument

*outputs:*

* multiple sequence alignments (Aligned FASTSA)

#### Reference Alignment Mode with Custom Guide Tree

Run basic multiple sequence alignment procedure with/without DPA with user provided guide trees in Newick format and scored against the reference alignment.

*inputs:*
 
* sequence file(s) (FASTA) using `--seqs` argument
* reference alignment file(s) using `--refs` argument
* guide tree file(s) (Newick) using `--trees` argument

*outputs:*

* multiple sequence alignments (Aligned FASTSA)
* tab seperated value file of alignments scored for SoP, Column and Total Column
