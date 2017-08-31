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
                ca-certificates \
                libpng12-0 \
                python-biopython \
                python-numpy \ 
                ruby \ 
                python-setuptools \
                default-jdk


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
    make install && \
    wget http://mafft.cbrc.jp/alignment/software/newick2mafft.rb && \
    chmod +x newick2mafft.rb

# Needed to unset for the new MAFFT version
ENV MAFFT_BINARIES=""

# Move the folder and remove the tar
RUN mv mafft-7.310-with-extensions mafft && \
    rm mafft-7.310-with-extensions-src.tgz


RUN rm clustal-omega-1.2.4.tar.gz && rm argtable2-13.tar.gz

# Install ProbCons
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    probcons

# Install MSAProbs
RUN wget "https://downloads.sourceforge.net/project/msaprobs/MSAProbs-0.9.7.tar.gz" -O msaprobs.tar.gz \
         && tar zxf msaprobs.tar.gz
WORKDIR /MSAProbs-0.9.7/MSAProbs
RUN make \
       && cp msaprobs /usr/bin
WORKDIR /


# 
# install SEPP and UPP 
#
#RUN git clone https://github.com/smirarab/sepp.git && \
#    cd sepp && \
#    git checkout 9b8cd6d13e677aa7cffee0ce4a85bbf23e6afa01 && \
#    python setup.py install && \
#    python setup.py config && \
#    python setup.py develop


#RUN mkdir pasta-code && \
#    cd pasta-code && \
#    git clone https://github.com/smirarab/pasta.git && \
#    git clone https://github.com/smirarab/sate-tools-linux.git && \
#    cd pasta && \
#    git checkout 6d52da14f48f55c10c26c3e6ad7bc2d5646feeaf && \
#    python setup.py develop -user && \ 
#    export PATH=$PATH:/pasta-code/pasta:/sepp  && \
#    cd  /sepp && \
#    python setup.py upp && \
#    cd /pasta-code/pasta && \ 
#    python setup.py develop

# Install TCOFFEE
RUN git clone https://github.com/cbcrg/tcoffee.git tcoffee && \
    cd tcoffee && \
    git checkout 7a55bbbb1417a8fc888619c1f73edcaf5c9add34 && \
    cd compile && \
    make t_coffee && \
    cp t_coffee /bin/. 

ENV CACHE_4_TCOFFEE=/tmp/tcoffee/cache
ENV LOCKDIR_4_TCOFFEE=/tmp/tcoffee/lock
ENV TMP_4_TCOFFEE=/tmp/tcoffee/tcf
ENV DIR_4_TCOFFEE=/tmp/tcoffee/dir
