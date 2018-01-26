Bootstrap:docker  
From:debian:jessie

%labels
MAINTAINER Evan Floden

%environment
  CACHE_4_TCOFFEE='${TMPDIR:-/tmp}/.tcoffee/cache'
  LOCKDIR_4_TCOFFEE='${TMPDIR:-/tmp}/.tcoffee/lock'
  TMP_4_TCOFFEE='${TMPDIR:-/tmp}/.tcoffee/tmp'
  PYTHONPATH=$PYTHONPATH:/home/lib/python2.7/site-packages/

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
  cd /

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
  cd /

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
  cd /

##
# install probcons
##
  apt-get install -y --no-install-recommends probcons

##
# install msaprobs
##
  wget "https://downloads.sourceforge.net/project/msaprobs/MSAProbs-0.9.7.tar.gz" -O msaprobs.tar.gz
  tar zxf msaprobs.tar.gz 
  cd MSAProbs-0.9.7/MSAProbs  
  make 
  cp msaprobs /usr/bin
  rm /msaprobs.tar.gz
  cd /

##
# install UPP 
##
  git clone http://github.com/smirarab/sepp.git
  cd sepp 
  mkdir -p /home/lib/python2.7/site-packages/ 
  export PYTHONPATH=$PYTHONPATH:/home/lib/python2.7/site-packages/ 
  python setup.py config -c
  echo "/home/" > /sepp/home.path 
  sed -i "s/root/home/g" /sepp/.sepp/main.config 
  python setup.py install --prefix=/home/ 
  python setup.py develop 
  mkdir /pasta-code 
  cd /pasta-code
  git clone https://github.com/smirarab/pasta.git
  git clone https://github.com/smirarab/sate-tools-linux.git
  cd pasta 
  python setup.py develop -user 
  export PATH=$PATH:/pasta-code/pasta:/sepp  
  cd  /sepp 
  python setup.py upp -c
  sed -i "s/root/home/g" /sepp/.sepp/upp.config 
  cd /pasta-code/pasta 
  python setup.py develop
  cd /

##
# install msa
##
  wget ftp://ftp.ncbi.nih.gov/pub/msa/msa.tar.Z
  tar xfvz msa.tar.Z 
  cd msa 
  make clean
  make msa
  rm /msa.tar.Z
  chmod +x /msa/msa 
  cp /msa/msa /bin/.
  cd /

##
# install tcoffee
##
  git clone https://github.com/cbcrg/tcoffee.git tcoffee
  cd tcoffee 
  git checkout ca33a72e644c85e3e0dc8576ac92d718772d67b2 
  cd compile
  make t_coffee
  cp t_coffee /bin/.
  cd /

##
# retrieve some test data
##
  mkdir /test_data
  cd test_data
  wget https://raw.githubusercontent.com/skptic/dpa-analysis/master/tutorial/seqs/rnasemam.fa
  wget https://raw.githubusercontent.com/skptic/dpa-analysis/master/tutorial/seqs/seatoxin.fa
  wget https://raw.githubusercontent.com/skptic/dpa-analysis/master/tutorial/refs/rnasemam.ref
  wget https://raw.githubusercontent.com/skptic/dpa-analysis/master/tutorial/refs/seatoxin.ref
  wget https://raw.githubusercontent.com/skptic/dpa-analysis/master/tutorial/trees/rnasemam.dnd 
  wget https://raw.githubusercontent.com/skptic/dpa-analysis/master/tutorial/trees/seatoxin.dnd 
