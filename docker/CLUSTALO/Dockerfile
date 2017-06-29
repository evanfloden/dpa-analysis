FROM debian:jessie
MAINTAINER Evan Floden <evanfloden@gmail.com>

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
                libargtable2-0

# install argtable 2
RUN wget --no-check-certificate http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz && \
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
     

