BRO ELK docker integration

=====================

This repository contains a **Dockerfile** of [Bro-IDS](http://www.bro.org/index.html) for [Docker](https://www.docker.io/)'s

Integrates Bro IDS 2.4-207 with Elasticsearch 2.0/2.1 & Kibana 4.2/4.3
Bro was compiled with broker,rocksdb and pybroker (full featured).
The bro scripts have been modified in order to satisfy elasticsearch.
The example below uses 3 elasticsearch nodes. The container bro-xinetd
writes to the master. Kibana reads from node02. The commandline bro uses
node01.

### Dependencies

* [![2.0.0](https://badge.imagelayers.io/debian.svg)](https://imagelayers.io/?images=debian:jessie 'jessie') debian:jessie
* [![2.0.0](https://badge.imagelayers.io/elasticsearch.svg)](https://imagelayers.io/?images=elasticsearch:2.0.0 '2.0.0') elasticsearch 2.0.0
* [![4.2.1](https://badge.imagelayers.io/kibana.svg)](https://imagelayers.io/?images=kibana:4.2.1 '4.2.1') kibana 4.2.1

### Image Size

* [![Latest](https://badge.imagelayers.io/danielguerra/bro-debian-elasticsearch.svg)](https://imagelayers.io/?images=danielguerra/bro-debian-elasticsearch:latest 'latest')

### elastic data

Create empty elasticsearch data volumes
optional,if not remove --volumes-from ...
```bash
docker create -v /usr/share/elasticsearch/data --name elastic-data-master danielguerra/empty-elastic-data /bin/true
docker create -v /usr/share/elasticsearch/data --name elastic-data-node01 danielguerra/empty-elastic-data /bin/true
docker create -v /usr/share/elasticsearch/data --name elastic-data-node02 danielguerra/empty-elastic-data /bin/true
```

### elasticsearch

Run three elasticsearch nodes (minimal)
```bash
docker run -d -p 9200:9200 -p 9300:9300 --volumes-from elastic-data-master --hostname=elasticsearch-master  --name elasticsearch-master  elasticsearch -Des.network.bind_host=elasticsearch-master --cluster.name=bro --node.name=elasticsearch-master --discovery.zen.ping.multicast.enabled=false --network.host=elasticsearch-master
docker run -d -p 9201:9200 -p 9301:9300 --volumes-from elastic-data-node01 --hostname=elasticsearch-node01  --name elasticsearch-node01  --link=elasticsearch-master:master elasticsearch -Des.network.bind_host=elasticsearch-node01 --cluster.name=bro --node.name=elasticsearch-node01 --discovery.zen.ping.unicast.hosts=master:9300  --network.host=elasticsearch-node01
docker run -d -p 9202:9200 -p 9302:9300 --volumes-from elastic-data-node02 --hostname=elasticsearch-node02  --name elasticsearch-node02  --link=elasticsearch-master:master elasticsearch -Des.network.bind_host=elasticsearch-node02 --cluster.name=bro --node.name=elasticsearch-node02 --discovery.zen.ping.unicast.hosts=master:9300  --network.host=elasticsearch-node02
```

### elasticsearch mapping (important)

After you have a running elasticsearch-cluster you should start a commandline bro and do
```bash
docker run --link elasticsearch-master:elasticsearch --rm danielguerra/bro-debian-elasticsearch /scripts/bro-mapping.sh
```
Then you are ready to go start reading data or dumping to the xinetd port

### kibana

Start the frond-end you can point your browser at http://<dockerhost>:5601/

```bash
docker run -d -p 5601:5601 --link=elasticsearch-node02:elasticsearch --hostname=kibana --name kibana kibana
```
 check my kabina config at
 https://github.com/danielguerra69/bro-debian-elasticsearch/blob/master/scripts/kibana.json

### bro on the commandline

```bash
docker run -ti --link elasticsearch-node01:elasticsearch -v /Users/PCAP:/pcap --name bro-dev danielguerra/bro-debian-elasticsearch /bin/bash
```
readfiles from bro-dev commandline

```bash
bro -r /pcap/mydump.pcap
```

### bro xinetd service
when role/xinetd is used no local logs are written
```bash
docker run -d -p 1969:1969 --link elasticsearch-master:elasticsearch --name bro-xinetd --hostname bro-xinetd danielguerra/bro-debian-elasticsearch /role/xinetd
```
tcpdump to your container from a remote host, replace dockerhost with your ip
```bash
tcpdump -i eth0 -s 0 -w /dev/stdout | nc dockerhost 1969```
or read a file file to your container
```bash
nc dockerhost 1969 < mydump.pcap
```

### bro ssh server

for bro nodes or just remote key based authentication
create an empty ssh volume
```bash
docker create -v /root/.ssh --name ssh-container danielguerra/ssh-container /bin/true
```
create your own keys on your own machine
```bash
docker run --volumes-from ssh-container debian:jessie ssh-keygen -q
```
add your pub key to authorized_keys file
```bash
docker run --volumes-from ssh-container debian:jessie cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
```
create a copy in your directory (pwd)
```bash
docker run --volumes-from ssh-container -v $(pwd):/backup debian:jessie cp -R /root/.ssh/* /backup
```
start bro as ssh daemon
```bash
docker run -d -p 1922:22 --link elasticsearch:elasticsearch --name bro-dev danielguerra/bro-debian-elasticsearch /role/sshd
ssh -p 1922 -i id_rsa root@dockerhost
```

### useful scripts

elastic-indices.sh shows elasticsearch indices
bro-mapping.sh bro mapping for kibana including geo_point mapping
remove-mapping.sh remove the mapping
clean-elastic.sh clean elasticsearch from bro data
update-intel.sh update intel for bro
