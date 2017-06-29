FROM debian:jessie
MAINTAINER Evan Floden <evanfloden@gmail.com>

## 
## Docker image for TCOFFEE DPA including all the requirements
## to run MAFFT_DPA, CLUSTALO_DPA and UPP_DPA
##

RUN apt-get update \ 
    && apt-get install -y --no-install-recommends \
		ed \
		less \
		vim-tiny \
		wget \
                git \
                python \ 
		build-essential \
		cmake \
		curl \
                libargtable2-0 \
                ca-certificates

# install argtable 2
RUN wget http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz && \
    tar -zxf argtable2-13.tar.gz && \
    cd argtable2-13 && \
    ./configure && \
    make && \
    make install 

# install CLUSTAL OMEGA
RUN wget http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz && \
    tar -zxf clustal-omega-1.2.4.tar.gz && \
    cd clustal-omega-1.2.4 && \
    ./configure && \
    make && \
    make install 

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

# 
# install SEPP and UPP 
#
RUN git clone https://github.com/smirarab/sepp.git && \
    cd sepp && \
    python setup.py config -c && \
    python setup.py install 

RUN mkdir pasta-code && \
    cd pasta-code && \
    git clone https://github.com/smirarab/pasta.git && \
    git clone https://github.com/smirarab/sate-tools-linux.git && \
    cd pasta && \
    python setup.py develop --user && \ 
    cd  /sepp && \
    python setup.py upp -c      

ENV PATH "$PATH:/pasta-code/pasta:/sepp"

# Install TCOFFEE
RUN git clone https://github.com/cbcrg/tcoffee.git tcoffee && \
    cd tcoffee && \
    cd compile && \
    make t_coffee && \
    cp t_coffee /bin/.

RUN rm clustal-omega-1.2.4.tar.gz && rm argtable2-13.tar.gz
