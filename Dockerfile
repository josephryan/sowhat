FROM ubuntu:xenial


# Installing necessary packages
RUN apt-get update && apt-get -y install perl-base git build-essential seq-gen r-base wget ncl-ncarg ncl-tools

# Moving to /opt
WORKDIR /opt

# Instaling dependencies
## Instaling R packages
RUN R -e "install.packages('ape', repos='http://cran.rstudio.com/')"

## installing perl packages
RUN cpan IPC::Run 
RUN cpan Statistics::R
RUN cpan JSON

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


