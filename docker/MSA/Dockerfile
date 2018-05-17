FROM debian:jessie
MAINTAINER Edgar Garriga <docker@edgargarriga.com>
LABEL "description"="This container contains MSA 2.1 software"

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
        ed \
        less \
        vim-tiny \
        wget \
        git \
        build-essential \
        cmake \
        libhdf5-dev \
        curl

# Download MSA and unzip
RUN wget ftp://ftp.ncbi.nih.gov/pub/msa/msa.tar.Z && \
    tar xfvz msa.tar.Z

# Clean and Install
RUN cd msa && \
    make clean && \
    make msa

# Add mafft to the PATH
ENV PATH "$PATH:/msa"

# Move the folder and remove the tar
RUN cd .. && \
    rm msa.tar.Z
