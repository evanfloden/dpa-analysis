FROM debian:jessie
MAINTAINER Evan Floden <evanfloden@gmail.com>

RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
		ed \
		less \
		vim-tiny \
		wget \
                git \
                python 


RUN apt-get update  && apt-get install -y \
		build-essential \
		cmake \
		libhdf5-dev \
		curl 

# 
# install SEPP 
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
    export PATH=$PATH:/pasta-code/pasta && \
    cd  /sepp && \
    python setup.py upp -c 
