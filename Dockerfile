FROM debian:jessie
# based on blacktop bro
MAINTAINER danielguerra, https://github.com/danielguerra

#Prevent daemon start during install
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
chmod +x /usr/sbin/policy-rc.d

ADD ElasticSearch.cc.patch /tmp/ElasticSearch.cc.patch

#set the path
ENV PATH /usr/local/bro/bin:$PATH
RUN echo "export PATH=$PATH:/usr/local/bro/bin" > /root/.profile

# add maintance shell scripts
ADD updateintel.sh /bin/updateintel.sh
ADD cleanelastic.sh /bin/cleanelastic.sh
ADD elasticsearchMapping.sh /bin/elasticsearchMapping.sh
ADD removeMapping.sh /bin/removeMapping.sh

# Install Bro Required Dependencies
RUN buildDeps='build-essential \
autoconf \
install-info \
libgoogle-perftools-dev \
libcurl3-dev \
libgeoip-dev \
libpcap-dev \
libssl-dev \
python-dev \
zlib1g-dev \
libedit-dev \
doxygen \
git-core \
cmake \
make \
g++ \
gcc \
libpcre3-dev \
python-setuptools \
libsnappy-dev \
libbz2-dev \
devscripts ' \
&& set -x \
&& echo "[INFO] Installing Dependancies..." \
&& apt-get -qq update \
&& apt-get -qq upgrade \
&& apt-get install -yq $buildDeps \
vim \
xinetd \
php5-curl \
sendmail \
bison \
flex \
gawk \
curl \
geoip-database \
geoip-database-extra \
wget \
ca-certificates \
openssh-server \
--no-install-recommends \
&& cd /tmp \
&& git clone --recursive https://github.com/kohler/ipsumdump.git \
&& cd /tmp/ipsumdump \
&& /bin/bash ./configure --enable-all-elements ;make; make install \
&& cd /tmp \
&& wget http://downloads.sourceforge.net/project/swig/swig/swig-3.0.7/swig-3.0.7.tar.gz \
&& tar xvfz swig-3.0.7.tar.gz \
&& cd /tmp/swig-3.0.7 \
&& ./configure \
&& make \
&& make install \
&& cd /tmp \
&& git clone --recursive https://github.com/facebook/rocksdb.git \
&& cd /tmp/rocksdb \
&& export CFLAGS="$CFLAGS -fPIC" && export CXXFLAGS="$CXXFLAGS -fPIC" \
&& make shared_lib \
&& make install \
&& export CFLAGS="" && export CXXFLAGS="" \
&& cd /tmp \
&& git clone --recursive --branch 0.14.2 https://github.com/actor-framework/actor-framework.git \
&& cd /tmp/actor-framework \
&& ./configure --no-examples --no-benchmarks --no-opencl \
&& make \
&& make install \
&& cd /tmp \
&& git clone --recursive git://git.bro.org/bro \
&& cd /tmp/bro \
&& ./configure \
&& make \
&& make install \
&& patch /tmp/bro/aux/plugins/elasticsearch/src/ElasticSearch.cc  /tmp/ElasticSearch.cc.patch \
&& sed -i "s/127.0.0.1/elasticsearch/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
&& sed -i "s/2secs/60secs/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
&& sed -i "s/const max_batch_size = 1000/const max_batch_size = 1/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
&& cd /tmp/bro/aux/plugins/elasticsearch \
&& ./configure \
&& make \
&& make install \
&& cd /tmp \
&& git clone --recursive https://github.com/jonschipp/mal-dnssearch.git \
&& cd /tmp/mal-dnssearch \
&& make \
&& apt-get remove -y $buildDeps \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD /custom /usr/local/bro/share/bro/custom
RUN echo "@load custom" >> /usr/local/bro/share/bro/base/init-default.bro
# update intel files
RUN /bin/updateintel.sh

#do some elasticsearch tweaks
#socks version causes type conflict
RUN sed -i "s/version:     count           \&log/socks_version:     count           \&log/g" /usr/local/bro/share/bro/base/protocols/socks/main.bro
RUN sed -i "s/\$version=/\$socks_version=/g" /usr/local/bro/share/bro/base/protocols/socks/main.bro

#ssh version conflict

#set sshd config for key based authentication for root
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config

# city v6 fix
ADD GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat

# bro pcap service
ADD bro /etc/xinetd.d/bro
RUN echo "bro             1969/tcp                        # bro pcap feed" >> /etc/services

#set the expose ports
EXPOSE 22
EXPOSE 1969
EXPOSE 47761
EXPOSE 47762

#set elasticsearch mapping
#CMD ["exec","/bin/elasticsearchMapping.sh"]

#start xinetd
CMD ["/usr/sbin/xinetd","-d"]
#start sshd
CMD ["/usr/sbin/sshd","-D"]
