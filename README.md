# dpa-analysis


## Quick Start

Make sure you have either docker/singularity installed or the required dependencies listed in the last section.

Install the Nextflow runtime by running the following command:

    $ curl -fsSL get.nextflow.io | bash


When done, you can launch the pipeline execution by entering the command shown below:

    $ nextflow run skptic/dpa-analysis
    

By default the pipeline is executed against the provided example dataset. 
Check the *Pipeline parameters*  section below to see how enter your data on the program 
command line.     
    

## Running Modes

There are 4 running modes which are determined based on the provided input files.

Each mode can be run with the standard MSA proceedure, with the DPA proceesure or with both (see `--dpa_align` and `--std_align`).

#### 1: Basic Alignment Mode

Run multiple sequence alignment procedure with/without DPA.

*inputs:* 

* sequence(s) files (FASTA) using `--seqs` argument

*outputs:*

* multiple sequence alignments (Aligned FASTA) 
* guide tree(s) used for the alignment

#### 2: Reference Alignment Mode

Run multiple sequence alignment procedure with/without DPA and score alignment against the reference alignment.

*inputs:*

* sequence file(s) (FASTA) using `--seqs` argument
* reference alignment file(s) using `--refs` argument

*outputs:*

* multiple sequence alignments (Aligned FASTA)
* tab seperated value file of alignments scored for SoP, Column and Total Column

#### 3: Custom Guide Tree Alignment Mode

Run basic multiple sequence alignment procedure with/without DPA with user provided guide trees in Newick format.

*inputs:*

* sequence file(s) (FASTA) using `--seqs` argument
* guide tree file(s) (Newick) using `--trees` argument

*outputs:*

* multiple sequence alignments (Aligned FASTA)

#### 4: Reference Alignment Mode with Custom Guide Tree

Run basic multiple sequence alignment procedure with/without DPA with user provided guide trees in Newick format and scored against the reference alignment.

*inputs:*
 
* sequence file(s) (FASTA) using `--seqs` argument
* reference alignment file(s) using `--refs` argument
* guide tree file(s) (Newick) using `--trees` argument

*outputs:*

* multiple sequence alignments (Aligned FASTSA)
* tab seperated value file of alignments scored for SoP, Column and Total Column 

## Pipeline parameters

#### `--seqs` 
   
* Specifies the location of the input *fasta* file(s).
* Multiple files can be specified using the usual wildcards (*, ?), in this case make sure to surround the parameter string
  value by single quote characters (see the example below)
* By default it is set to the location: `./tutorial/seqs/*.fa`

Example: 

    $ nextflow run skptic/dpa-analysis --seqs '/home/seqs/*.fasta'

This will handle each fasta file as a seperate sample.

