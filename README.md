# Fast and accurate large multiple sequence alignments using root-to-leave regressive computation

For details on how to use the Regressive multiple sequence alignment method, see the [T-Coffee documentation](https://tcoffee.readthedocs.io/en/latest/tcoffee_quickstart_regressive.html?highlight=regressive#quick-start-regressive-algorithm) for the regressive alignment.

This repository contains data, documentation, analysis and a workflow for the manuscript "Fast and accurate large multiple sequence alignments using root-to-leave regressive computation".

### Credits
This workflow was written by Evan Floden ([evanfloden](https://github.com/evanfloden)) and 
Edgar([edgano](https://github.com/edgano)) at the [Center for Genomic Regulation (CRG)](http://www.crg.eu).

The authors who contributed to the analysis and manuscript are:

* Edgar Garriga Nogales
* Paolo Di Tommaso
* Cedrik Magis
* Ionas Erb
* Hafid Laayouni
* Fyodor Kondrashov
* Evan Floden
* Cedric Notredame


### Notebooks
This repository contains a series of [Jupyter Notebooks](http://jupyter.org/) that contain 
the steps for replicating the analysis, tables and figures in the manuscript.

The index jupyter notebook can be found [here](notebook/00_StartHere.ipynb).

The notebook executes the pipeline, some steps of which require a lot of resources.

### Pipeline
The pipeline for generating trees, alignments and performing the evaluations is built using 
[Nextflow](https://www.nextflow.io), a workflow tool to run tasks across 
multiple compute infrastructures in a very portable manner. It comes with a docker container 
making installation trivial and results highly reproducible.


### Pipeline Quick Start
Make sure you have either docker/singularity installed or the required dependencies listed 
in the last section.

Install the Nextflow runtime by running the following command:

    $ curl -fsSL get.nextflow.io | bash


When done, you can launch the pipeline execution by entering the command shown below:

    $ nextflow run evanfloden/dpa-analysis
    

By default the pipeline is executed against the provided example dataset. 
Check the *Pipeline parameters*  section below to see how enter your data on the program 
command line.     
  

### Containers

All the methods above are available in a [Docker](http://www.docker.com) image on DockerHub [here](https://hub.docker.com/r/cbcrg/regressive-msa/) and the image is tested to be compatible with the [Singularity](http://singularity.lbl.gov/).

The container also contains test data consisting of protein sequences, reference alignments and trees in the directory `/test_data`.

To launch the container interactively with Docker run:

`docker run cbcrg/regressive-msa`

To launch the container interactivly with Singularity run:

`singularity shell docker://cbcrg/regressive-msa`


### Pipeline parameters

#### `--seqs` 
   
* Specifies the location of the input *fasta* file(s).
* Multiple files can be specified using the usual wildcards (*, ?), in this case make sure to surround the parameter string
  value by single quote characters (see the example below)

Example: 

    $ nextflow run evanfloden/dpa-analysis --seqs '/home/seqs/*.fasta'

This will handle each fasta file as a seperate sample.


#### `--refs` 

* Specifies the location of the reference *aligned fasta* file(s).


#### `--trees` 

* Specifies the location of input tree file(s).


#### `--align_method` 

* Specifies which alignment methods should be used.
* Options include: "CLUSTALO,MAFFT-FFTNS1,MAFFT-SPARSECORE,MAFFT-GINSI,PROBCONS,UPP"


#### `--tree_method` 

* Specifies which guide-tree / clustering methods should be used.
* Options include: "CLUSTALO,MAFFT_PARTTREE"


#### `--regressive_align` 

* Flag to generate regressive MSAs.
* See `templates/dpa_align` for the specific commands executed.


#### `--stardard_align` 

* Flag to perform standard MSAs.
* Standard MSA is alignment where the guide-tree is provided as input.
* See `templates/std_align` for the specific commands executed.


#### `--default_align` 

* Flag to perform default MSAs.
* Default MSA is alignment where the alignment software uses an internally generated guide-tree.
* See `templates/default_align` for the specific commands executed.


#### `--evaluate` 

* Flag to perform evaluation of the alignments.
* Requires reference sequences to be provided with the `--refs` parameter.


#### `--buckets` 

* List of bucket sizes or maximum size of the subMSAs in the regressive proceedure.
* Default value is "1000" sequences.


#### `--output`

* Location of the results.
* Default locations is `results` directory.






