FROM debian:jessie
MAINTAINER Evan Floden <evanfloden@gmail.com>

RUN apt-get update \ 
	&& apt-get install -y \
		ed \
		less \
		vim-tiny \
		wget \
                git \
                python2.7 \
                python \
                python-setuptools \
                default-jdk

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
    git checkout 9b8cd6d13e677aa7cffee0ce4a85bbf23e6afa01 && \
    python setup.py install && \
    python setup.py config && \
    python setup.py develop

RUN mkdir pasta-code && \
    cd pasta-code && \
    git clone https://github.com/smirarab/pasta.git && \
    git clone https://github.com/smirarab/sate-tools-linux.git && \
    cd pasta && \
    git checkout 6d52da14f48f55c10c26c3e6ad7bc2d5646feeaf && \
    python setup.py develop -user && \ 
    export PATH=$PATH:/pasta-code/pasta && \
    cd  /sepp && \
    python setup.py upp && \
    cd /pasta-code/pasta && \ 
    python setup.py develop
