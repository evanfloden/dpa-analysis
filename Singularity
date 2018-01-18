Bootstrap:docker  
From:debian:jessie

%labels
MAINTAINER Evan Floden

%post
  apt-get update
  apt-get install -y --no-install-recommends ed less vim-tiny wget git
  apt-get install -y --no-install-recommends python build-essential cmake curl libargtable2-0
  apt-get install -y --no-install-recommends python-biopython python-numpy ruby python-setuptools
  apt-get install -y --no-install-recommends default-jdk libpng-dev


##
# install argtable
##
  wget http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz
  tar -zxf argtable2-13.tar.gz 
  cd argtable2-13
  ./configure
  make
  make install
  rm /argtable2-13.tar.gz

##
# install clustal omega
##
  wget http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz
  tar -zxf clustal-omega-1.2.4.tar.gz
  cd clustal-omega-1.2.4
  ./configure
  make
  make install
  rm /clustal-omega-1.2.4.tar.gz

##
# install mafft
##
  wget http://mafft.cbrc.jp/alignment/software/mafft-7.310-with-extensions-src.tgz
  tar xfvz mafft-7.310-with-extensions-src.tgz
  cd mafft-7.310-with-extensions/core/
  sed -i "s/PREFIX = \/usr\/local/PREFIX = \/mafft/g" Makefile 
  sed -i "s/BINDIR = \$(PREFIX)\/bin/BINDIR = \/mafft\/bin/g" Makefile
  make clean
  make
  make install
  wget http://mafft.cbrc.jp/alignment/software/newick2mafft.rb
  chmod +x newick2mafft.rb
  export "PATH=$PATH:/mafft/bin"
  export MAFFT_BINARIES=""
  cp /mafft/bin/* /bin/.
  mv /mafft-7.310-with-extensions /mafft
  rm /mafft-7.310-with-extensions-src.tgz

##
# Install probcons
##
  apt-get install -y --no-install-recommends probcons

