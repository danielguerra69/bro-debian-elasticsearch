### Dependencies

* [debian:jessie (*125.2  MB*)](https://index.docker.io/_/debian/)

### Image Size
[![Latest](https://badge.imagelayers.io/danielguerra/bro-debian-elasticsearch.svg)](https://imagelayers.io/?images=danielguerra/bro-debian-elasticsearch:latest 'latest')

BRO ELK docker integration
==========================

Integrates Bro IDS 2.4-207 with Elasticsearch 2.0 & Kibana 2.4.1
Bro was compiled with broker,rocksdb and pybroker (full featured).
Bro doesn't write local logfiles and only logs to elasticsearch.

### elastic data

volume with mapping and kibana vieuws
```bash
$ docker create -v /usr/share/elasticsearch/data --name elastic-data-master danielguerra/empty-elastic-data /bin/true
$ docker create -v /usr/share/elasticsearch/data --name elastic-data-node01 danielguerra/empty-elastic-data /bin/true
```
### elasticsearch
```bash
$ docker run -d -p 9200:9200 -p 9300:9300 --volumes-from elastic-data-master --hostname=elasticsearch-master  --name elasticsearch-master  elasticsearch -Des.network.bind_host=elasticsearch-master --cluster.name=bro --node.name=elasticsearch-master --discovery.zen.ping.multicast.enabled=false --network.host=elasticsearch-master
$ docker run -d -p 9201:9200 -p 9301:9300 --volumes-from elastic-data-node01 --hostname=elasticsearch-node01  --name elasticsearch-node01  --link=elasticsearch-master:master elasticsearch -Des.network.bind_host=elasticsearch-node01 --cluster.name=bro --node.name=elasticsearch-node01 --discovery.zen.ping.unicast.hosts=master:9300  --network.host=elasticsearch-node01
```
### kibana
```bash
$ docker run -d -p 5601:5601 --link=elasticsearch-master:elasticsearch --hostname=kibana --name kibana kibana
```
### start bro on the commandline
```bash
$ docker run -ti --link elasticsearch-master:elasticsearch -v /Users/PCAP:/pcap --name bro-dev danielguerra/bro-debian-elasticsearch /bin/bash
```
readfiles from bro-dev commandline
```bash
$ bro -r /pcap/mydump.pcap
```
### bro xinetd service
```bash
$ docker run -d -p 1969:1969 --link elasticsearch-master:elasticsearch --name bro-xinetd --hostname bro-xinetd danielguerra/bro-debian-elasticsearch /usr/sbin/xinetd -dontfork
```
tcpdump to your container from a remote host, replace dockerhost with your ip
```bash
$ tcpdump -i eth0 -s 0 -w /dev/stdout | nc dockerhost 1969
```
or read a file file to your container
```bash
$ nc dockerhost 1969 < mydump.pcap
```
### bro ssh server

for bro nodes or just remote key based authentication
create an empty ssh volume
```bash
$ docker create -v /root/.ssh --name ssh-container danielguerra/ssh-container /bin/true
```
create your own keys on your own machine
```bash
$ docker run --volumes-from ssh-container debian:jessie ssh-keygen -q
```
add your pub key to authorized_keys file
```bash
$ docker run --volumes-from ssh-container debian:jessie cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
```
create a copy in your directory (pwd)
```bash
$ docker run --volumes-from ssh-container -v $(pwd):/backup debian:jessie cp -R /root/.ssh/* /backup
```
start bro as deamon
```bash
$ docker run -d -p 1922:22 --link elasticsearch:elasticsearch --name bro-dev danielguerra/bro-debian-elasticsearch
$ ssh -p 1922 -i id_rsa root@dockerhost
```
### useful scripts

elasticsearchMapping.sh bro mapping for kibana including geo_point mapping
removeMapping.sh remove the mapping
cleanelastic.sh clean elasticsearch from bro data
updateintel.sh update intel for bro
