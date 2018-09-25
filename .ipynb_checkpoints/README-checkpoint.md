# Regressive Alignment Analysis

### Introduction
The pipeline is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across 
multiple compute infrastructures in a very portable manner. It comes with docker / singularity containers 
making installation trivial and results highly reproducible.

### Documentation
The dpa-analysis pipeline comes with documentation about the pipeline, found in the `docs/` directory:

1. [Installation](docs/installation.md)
2. Pipeline configuration
    * [Local installation](docs/configuration/local.md)
    * [Adding your own system](docs/configuration/adding_your_own.md)
3. [Running the pipeline](docs/usage.md)
4. [Output and how to interpret the results](docs/output.md)
5. [Troubleshooting](docs/troubleshooting.md)

### Credits
This pipeline was written by Evan Floden ([evanfloden](https://github.com/evanfloden)) and 
Edgar at [Center for Genomic Regulation (CRG)](http://www.crg.eu).

## Notebook
This repository contains a the main workflow written in Nextflow as well as a series of [jupyter 
notebooks](http://jupyter.org/) that contain the steps for replicating the analysis.

The initial jupyter notebook can be found [here](notebook/00_StartHere.ipynb).


## Quick Start
Make sure you have either docker/singularity installed or the required dependencies listed 
in the last section.

Install the Nextflow runtime by running the following command:

    $ curl -fsSL get.nextflow.io | bash


When done, you can launch the pipeline execution by entering the command shown below:

    $ nextflow run evanfloden/dpa-analysis
    

By default the pipeline is executed against the provided example dataset. 
Check the *Pipeline parameters*  section below to see how enter your data on the program 
command line.     
  




## Containers

All the methods above are available in a [Docker](http://www.docker.com) image on DockerHub [here](https://hub.docker.com/r/cbcrg/regressive-msa/) and the image is tested to be compatible with the [Singularity](http://singularity.lbl.gov/).

The container also contains test data consisting of protein sequences, reference alignments and trees in the directory `/test_data`.

To launch the container interactively with Docker run:

`docker run cbcrg/regressive-msa`

To launch the container interactivly with Singularity run:

`singularity shell docker://cbcrg/regressive-msa`


## Pipeline parameters

#### `--seqs` 
   
* Specifies the location of the input *fasta* file(s).
* Multiple files can be specified using the usual wildcards (*, ?), in this case make sure to surround the parameter string
  value by single quote characters (see the example below)
* By default it is set to the location: `./tutorial/seqs/*.fa`

Example: 

    $ nextflow run skptic/dpa-analysis --seqs '/home/seqs/*.fasta'

This will handle each fasta file as a seperate sample.

