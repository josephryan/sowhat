FROM ubuntu:xenial


# Installing necessary packages
RUN apt-get update && apt-get -y install perl-base git build-essential seq-gen r-base wget ncl-ncarg ncl-tools

# Moving to /opt
WORKDIR /opt

# Instaling dependencies
## Installing RaxML
RUN git clone https://github.com/stamatak/standard-RAxML.git
WORKDIR standard-RAxML
RUN make -f Makefile.SSE3.PTHREADS.gcc
RUN rm *.o
RUN ln -s /opt/standard-RAxML/raxmlHPC-PTHREADS-SSE3 /usr/bin/raxml
#RUN raxml --version
WORKDIR /opt

## Instaling Garli
RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/garli/garli-2.01.tar.gz
RUN tar zxvf garli-2.01.tar.gz
WORKDIR garli-2.01 
RUN ./build_garli.sh
RUN ln -s /opt/garli-2.01/bin/Garli-2.01 /usr/bin/Garli
WORKDIR /opt

## Instaling R packages
RUN R -e "install.packages('ape', repos='http://cran.rstudio.com/')"

## installing perl packages
RUN cpan IPC::Run 
RUN cpan Statistics::R
RUN cpan JSON

## Installing PhyloBayes
RUN wget http://megasun.bch.umontreal.ca/People/lartillot/www/phylobayes4.1c.tar.gz
RUN tar zxvf phylobayes4.1c.tar.gz
WORKDIR phylobayes4.1c/sources
RUN make 
RUN ln -s /opt/phylobayes4.1c/data/* /usr/bin/
WORKDIR /opt

# cloning sowhat in /opt

copy . sowhat

# installing sowhat
WORKDIR /opt/sowhat
RUN ./build_3rd_party.sh
RUN perl Makefile.PL
RUN make 
RUN make test 
RUN make install

# Making the directories for volume mounting
RUN mkdir /Data
RUN mkdir /Results


