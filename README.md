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
    
## Alignment Methods

The following alignment methods are available. 

| Method | Default | Regressive | Standard | Version |
| --- | :---:  | :---:  | :---:  | ------- |
| CLUSTALO | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | 1.2.4 |
| MAFFT | :heavy_check_mark: | :heavy_check_mark: |:heavy_check_mark: |v7.310 |
| MAFFT-GINSI |	:heavy_check_mark: |	:heavy_check_mark: |	:heavy_check_mark: |	v7.310 |
| MAFFT-SPARSECORE | :heavy_check_mark: | :heavy_multiplication_x: | :heavy_multiplication_x: | v7.310 |
| UPP |	:heavy_check_mark: |	:heavy_check_mark: |	:heavy_multiplication_x: |	4.3.4 |
| PROBCONS | :heavy_check_mark: | :heavy_check_mark: | :heavy_multiplication_x: | 1.12 |
| MSA |	:heavy_exclamation_mark: | :heavy_exclamation_mark: | :heavy_exclamation_mark: |	2.1 |
| MSAPROBS | :heavy_check_mark: | :heavy_check_mark: |:heavy_multiplication_x: |0.9.7 |
| TCOFFEE |	:heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |	dev_@20180108_13:55 |

## Tree Building Methods

| Method | Available? | Version |
| --- | :---:  | ------- |
| CLUSTALO | :heavy_check_mark: | 1.2.4 |
| MAFFT | :heavy_check_mark: | v7.310 |
| MAFFT-PT | :heavy_check_mark: | v7.310 |
| UPGMA (TCOFFEE) | :heavy_exclamation_mark: | dev_@20180108_13:55  |
| NJ (TCOFFEE) |	:heavy_check_mark: |	dev_@20180108_13:55  |


## Containers

All the methods above are available in a [Docker](http://www.docker.com) image on DockerHub [here](https://hub.docker.com/r/cbcrg/regressive-msa/) and the image is tested to be compatible with the [Singularity](http://singularity.lbl.gov/).

The container also contains test data consisting of protein sequences, reference alignments and trees in the directory `/test_data`.

To launch the container interactively with Docker run:

`docker run cbcrg/regressive-msa`

To launch the container interactivly with Singularity run:

`singularity shell docker://cbcrg/regressive-msa`



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

