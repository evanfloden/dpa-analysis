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
               ca-certificates

#msaprobs
RUN wget "https://downloads.sourceforge.net/project/msaprobs/MSAProbs-0.9.7.tar.gz" -O msaprobs.tar.gz \
         && tar zxf msaprobs.tar.gz
WORKDIR /MSAProbs-0.9.7/MSAProbs
RUN make \
       && cp msaprobs /usr/bin
WORKDIR /

