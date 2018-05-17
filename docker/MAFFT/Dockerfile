FROM debian:jessie
MAINTAINER Edgar Garriga <docker@edgargarriga.com>
LABEL "description"="This container contains MAFFT 7.310 with extensions"

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

# Download MAFFT
RUN wget http://mafft.cbrc.jp/alignment/software/mafft-7.310-with-extensions-src.tgz && \
    tar xfvz mafft-7.310-with-extensions-src.tgz

# Configure and install
RUN cd mafft-7.310-with-extensions/core/ && \
    sed -i "s/PREFIX = \/usr\/local/PREFIX = \/mafft/g" Makefile && \
    sed -i "s/BINDIR = \$(PREFIX)\/bin/BINDIR = \/mafft\/bin/g" Makefile

# Add mafft to the PATH
ENV PATH "$PATH:/mafft/bin"

# Make
RUN cd mafft-7.310-with-extensions/core/ && \
    make clean && \
    make && \
    make install

# Needed to unset for the new MAFFT version
ENV MAFFT_BINARIES=""

# Move the folder and remove the tar
RUN mv mafft-7.310-with-extensions mafft && \
    rm mafft-7.310-with-extensions-src.tgz

