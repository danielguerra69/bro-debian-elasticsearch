FROM debian:jessie

# based on blacktop bro
MAINTAINER danielguerra, https://github.com/danielguerra

#set the path
ENV PATH /usr/local/bro/bin:/scripts:$PATH
RUN echo "export PATH=$PATH:/usr/local/bro/bin:/scripts" > /root/.profile

# add patches for bro to work with elasticsearch 2.0 (remove . set correct time)
ADD /bro-patch /bro-patch

# Install Bro + Required Dependencies
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
devscripts \
libjemalloc-dev \
libjemalloc1-dbg ' \
&& set -x \
&& echo "[INFO] Installing Dependancies..." \
&& apt-get -qq update \
&& apt-get -qq upgrade \
&& apt-get install -yq $buildDeps \
libjemalloc1 \
amqp-tools \
locales \
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
openssh-server --no-install-recommends \
&& export LANGUAGE="en_US:en" \
&& export LANG="en_US.UTF-8" \
&& locale-gen "en_US.UTF-8" \
&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
&& dpkg-reconfigure -f noninteractive locales \
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
&& patch /tmp/bro/aux/plugins/elasticsearch/src/ElasticSearch.cc  /bro-patch/ElasticSearch.cc.patch \
&& patch /tmp/bro/src/threading/formatters/JSON.h /bro-patch/JSON.h.patch \
&& patch /tmp/bro/src/threading/formatters/JSON.cc /bro-patch/JSON.cc.patch \
&& cd /tmp/bro \
&& ./configure \
&& make \
&& make install \
&& sed -i "s/127.0.0.1/elasticsearch/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
&& sed -i "s/2secs/60secs/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
&& sed -i "s/const max_batch_size = 1000/const max_batch_size = 500/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
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

# add maintance shell scripts
ADD /scripts /scripts

#add extra bro files
ADD /bro-extra /usr/local/bro/share/bro/bro-extra
RUN echo "@load bro-extra" >> /usr/local/bro/share/bro/base/init-default.bro

# add botflex
RUN cd /usr/local/bro/share/bro/  \
&& git clone --recursive https://github.com/sheharbano/botflex.git botflex
# && echo "@load botflex/detection/correlation/correlation.bro" >> base/init-default.bro

# add dr watson
RUN cd /usr/local/bro/share/bro/  \
&& git clone --recursive https://github.com/broala/bro-drwatson.git drwatson
#&& echo "@load drwatson" >> base/init-default.bro

# add shellshock
RUN cd /usr/local/bro/share/bro/  \
&& git clone --recursive https://github.com/broala/bro-shellshock.git shellshock \
&& echo "@load shellshock" >> base/init-default.bro

# add bro-scripts
RUN cd /usr/local/bro/share/bro/  \
&& git clone --recursive https://github.com/reservoirlabs/bro-scripts.git bro-scripts
# && echo "@load bro-scripts/clickbot" >> local.bro \
#&& echo "@load bro-scripts/supercomputing/producer-consumer-ratio" >> local.bro \
#&& echo "@load bro-scripts/supercomputing/protocol-stats" >> local.bro \
#&& echo "@load bro-scripts/supercomputing/http-exe-bad-attributes" >> local.bro \
#&& echo "@load bro-scripts/supercomputing/smtp-url" >> local.bro \
#&& echo "@load bro-scripts/supercomputing/top-metrics" >> base/init-default.bro \
#&& echo "@load bro-scripts/supercomputing/unique-hosts" >> base/init-default.bro \
#&& echo "@load bro-scripts/supercomputing/unique-macs" >> base/init-default.bro\
#&& echo "@load bro-scripts/track-dhcp/track-dhcp" >> base/init-default.bro

# add bro service
RUN echo "bro             1969/tcp                        # bro pcap feed" >> /etc/services

#fresh intel
RUN /scripts/update-intel.sh
#set the expose ports
EXPOSE 22
EXPOSE 1969
EXPOSE 47761
EXPOSE 47762

#set default dir
WORKDIR /tmp

#Add geolitecityv6
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
RUN gunzip GeoLiteCityv6.dat.gz
RUN mv GeoLiteCityv6.dat /usr/share/GeoIP/GeoLiteCityv6.dat
RUN ln -s /usr/share/GeoIP/GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat

# Do some elasticsearch tweaks (couldnt solve it with mapping :`( )
# elastic is not happy about version, type change count/string
RUN sed -i "s/version:     count           \&log/socks_version:     count           \&log/g" /usr/local/bro/share/bro/base/protocols/socks/main.bro
RUN sed -i "s/\$version=/\$socks_version=/g" /usr/local/bro/share/bro/base/protocols/socks/main.bro
RUN sed -i "s/version:          string \&log/ssl_version:     string \&log/g" /usr/local/bro/share/bro/base/protocols/ssl/main.bro
RUN sed -i "s/\$version=/\$ssl_version=/g" /usr/local/bro/share/bro/base/protocols/ssl/main.bro
RUN sed -i "s/version:         count        \&log/ssh_version:         count        \&log/g" /usr/local/bro/share/bro/base/protocols/ssh/main.bro
RUN sed -i "s/\$version =/\$ssh_version =/g" /usr/local/bro/share/bro/base/protocols/ssh/main.bro
RUN sed -i "s/version: string \&log/snmp_version: string \&log/g" /usr/local/bro/share/bro/base/protocols/snmp/main.bro
RUN sed -i "s/\$version=/\$snmp_version=/g" /usr/local/bro/share/bro/base/protocols/snmp/main.bro

#no longer needed, thanks Seth commit 4e4dece70a114b6e6dc8e499bca694f8616eae2f
# request_body_len type change for sip
#RUN sed -i "s/request_body_len:        string            \&log/req_body_len:        string            \&log/g" /usr/local/bro/share/bro/base/protocols/sip/main.bro
#RUN sed -i "s/\$request_body_len =/\$req_body_len =/g" /usr/local/bro/share/bro/base/protocols/sip/main.bro
# response_body_len type change for sip
#RUN sed -i "s/response_body_len:       string            \&log/resp_body_len:        string            \&log/g" /usr/local/bro/share/bro/base/protocols/sip/main.bro
#RUN sed -i "s/\$response_body_len =/\$resp_body_len =/g" /usr/local/bro/share/bro/base/protocols/sip/main.bro

# fix error in kerberos
RUN patch /usr/local/bro/share/bro/base/protocols/krb/main.bro /bro-patch/krb-main.patch

# bro pcap-in tcp services
ADD /xinetd /xinetd

# add role scripts
ADD /role /role

CMD ["/role/cmd-bare"]
