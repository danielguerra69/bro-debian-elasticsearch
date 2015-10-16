FROM debian:jessie
# based on blacktop bro
MAINTAINER danielguerra, https://github.com/danielguerra

#Prevent daemon start during install
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
chmod +x /usr/sbin/policy-rc.d

# Install Bro Required Dependencies
RUN \
apt-get -qq update && \
apt-get -qq upgrade && \
apt-get install -yq libgoogle-perftools-dev \
build-essential \
ca-certificates \
libcurl3-dev \
libgeoip-dev \
libpcap-dev \
libssl-dev \
python-dev \
zlib1g-dev \
libedit-dev \
doxygen \
php5-curl \
git-core \
sendmail \
bison \
cmake \
flex \
gawk \
make \
curl \
g++ \
geoip-database \
geoip-database-extra \
tor-geoipdb \
gcc \
wget \
libpcre3-dev \
python-setuptools

#swig latest for broker python integration
WORKDIR /tmp
RUN wget http://prdownloads.sourceforge.net/swig/swig-3.0.7.tar.gz
RUN tar xvfz swig-3.0.7.tar.gz
WORKDIR /tmp/swig-3.0.7
RUN ./configure
RUN make
RUN make install

#rocksdb gives
WORKDIR /tmp
RUN git clone --recursive https://github.com/facebook/rocksdb.git
WORKDIR /tmp/rocksdb
RUN export CFLAGS="$CFLAGS -fPIC" && export CXXFLAGS="$CXXFLAGS -fPIC" && make static_lib
RUN export CFLAGS="$CFLAGS -fPIC" && export CXXFLAGS="$CXXFLAGS -fPIC" && make install

# ipsumdump
WORKDIR /tmp
RUN git clone --recursive https://github.com/kohler/ipsumdump.git
WORKDIR /tmp/ipsumdump
RUN ./configure
RUN make
RUN make install

#actor framework caf to enable broker
WORKDIR /tmp
RUN git clone --recursive --branch 0.14.2 https://github.com/actor-framework/actor-framework.git
WORKDIR /tmp/actor-framework
RUN ./configure --no-examples --no-benchmarks --no-opencl
RUN make
RUN make install

# bro
WORKDIR /tmp
RUN  git clone --recursive git://git.bro.org/bro
WORKDIR /tmp/bro
RUN ./configure --disable-broker
RUN make
RUN make install

# ELK integration
# Do some kibana changes timestamp and elastic configuration
RUN sed -i "s/JSON::TS_MILLIS/JSON::TS_ISO8601/g" /tmp/bro/aux/plugins/elasticsearch/src/ElasticSearch.cc
RUN sed -i "s/127.0.0.1/elasticsearch/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro
RUN sed -i "s/2secs/60secs/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro
WORKDIR /tmp/bro/aux/plugins/elasticsearch
RUN ./configure
RUN make
RUN make install

# mal-dns for some intel
WORKDIR /tmp
RUN git clone --recursive https://github.com/jonschipp/mal-dnssearch.git
WORKDIR /tmp/mal-dnssearch
RUN make

# for geohash example python execute
WORKDIR /tmp
RUN wget https://pypi.python.org/packages/source/G/Geohash/Geohash-1.0.tar.gz#md5=a7c4e57874061fae1e30dd8aa8b9b390
RUN tar xvfz Geohash-1.0.tar.gz
WORKDIR /tmp/Geohash-1.0
RUN python setup.py build
RUN python setup.py install
# clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#set the path
ENV PATH /usr/local/bro/bin:$PATH

# add custom scripts
ADD custom /usr/local/bro/share/bro/custom
RUN /bin/sh /usr/local/bro/share/bro/custom/updateintel.sh

ENTRYPOINT ["bro"]

CMD ["-h"]
