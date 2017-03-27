##### BRO ELK AMQP docker integration

|  Bro IDS   |  Elasticsearch + Kibana | RabbitMQ   |
| :--- | :--- | :--- |
| ![Bro IDS](https://www.bro.org/images/bro-eyes.png) | ![Elasticsearch](https://www.runabove.com/images/apps/elasticsearch-and-kibana.png) | ![RabbitMQ](https://www.rabbitmq.com/img/rabbitmq_logo_strap.png) |
<<<<<<< HEAD:Readme.rst
|  2.5-beta   |  2.4 + 4.6 | 3.5.7  |

### About

Integrates Bro IDS git 2.5-beta with Elasticsearch 2.4 & Kibana 4.6.
=======
|  2.5   |  2.4 + 4.6 | 3.5.7  |

### About

Integrates Bro IDS git 2.5 with Elasticsearch 2.4 & Kibana 4.6.
>>>>>>> master:Readme.md
Bro was compiled with broker,rocksdb and pybroker (full featured).
Bro can write directly into Elasticsearch without logstash.
The bro scripts have been modified in order to satisfy elasticsearch.
The example below uses 3 elasticsearch nodes. The container bro-xinetd
writes to the master. Kibana reads from node02. The commandline bro uses
node01.
Added amqp (rabbitmq) consume/publish roles with the debian amqp-tools.

### Docker-compose

The simplest way to start all nodes is using docker-compose
The DOCKERHOST is the ip and port the user sees in kibana !
The port from the compose file is 8080.
```bash
export DOCKERHOST="<ip>:8080"
wget https://raw.githubusercontent.com/danielguerra69/bro-debian-elasticsearch/master/docker-compose.yml
docker-compose pull
docker-compose up
```
This compose file starts a role/xinetd-forensic which currently supports pcap and extracted file access from kibana.
It listens to port 1969 for pcap files.
```bash
nc <dockerhost-ip> 1969 < my.pcap
tcpdump -i eth0 -s 0 -w - not host <dockerhost-ip> | nc <dockerhost-ip> 1969
```
Kibana is viewed in your browser.
http://<dockerhost-ip>:5601/

The pcap and extracted data can be reached over tcp port 8080

[Screenshot !](https://raw.githubusercontent.com/danielguerra69/bro-debian-elasticsearch/master/bro-kibana.gif)


### Developers

Full version with all tools and sources to build this project.
Sources are in /tmp.
```bash
docker pull danielguerra/bro-debian-elasticsearch:develop
```

#### Installation

Before you begin I recommend to start with pulling fresh images.
```bash
docker pull danielguerra/bro-debian-elasticsearch
docker pull elasticsearch (or latest)
docker pull kibana (or latest)
docker pull rabbitmq:3.5.6-management
```
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
docker run -d --volumes-from elastic-data-master --hostname=elasticsearch-master  --name elasticsearch-master  elasticsearch -Des.network.bind_host=elasticsearch-master --cluster.name=bro --node.name=elasticsearch-master --discovery.zen.ping.multicast.enabled=false --network.host=elasticsearch-master
docker run -d --volumes-from elastic-data-node01 --hostname=elasticsearch-node01  --name elasticsearch-node01  --link=elasticsearch-master:master elasticsearch -Des.network.bind_host=elasticsearch-node01 --cluster.name=bro --node.name=elasticsearch-node01 --discovery.zen.ping.unicast.hosts=master:9300  --network.host=elasticsearch-node01
docker run -d --volumes-from elastic-data-node02 --hostname=elasticsearch-node02  --name elasticsearch-node02  --link=elasticsearch-master:master elasticsearch -Des.network.bind_host=elasticsearch-node02 --cluster.name=bro --node.name=elasticsearch-node02 --discovery.zen.ping.unicast.hosts=master:9300  --network.host=elasticsearch-node02
```

### elasticsearch mapping (important)

After you have a running elasticsearch-cluster you should start a commandline bro and do
```bash
docker run --link elasticsearch-master:elasticsearch --rm danielguerra/bro-debian-elasticsearch /scripts/bro-mapping.sh
```

### kibana

Configure kibana
```bash
docker run --rm --link elasticsearch-master:elasticsearch danielguerra/bro-kibana-config
```

Start kibana
```bash
docker run -d -p 5601:5601 --link=elasticsearch-node02:elasticsearch --hostname=kibana --name kibana kibana
```
Point your browser http://<dockerhost>:5601

### bro on the commandline

commandline and local file log
```bash
docker run -ti -v /Users/PCAP:/pcap --name bro-log danielguerra/bro-debian-elasticsearch
```

commandline and log to elasticsearch
```bash
docker run -ti --link elasticsearch-node01:elasticsearch -v /Users/PCAP:/pcap --name bro danielguerra/bro-debian-elasticsearch /role/cmd-elasticsearch
```
readfiles from bro commandline

```bash
bro -r /pcap/mydump.pcap
```

bro develop version (all sources are in /tmp)
```
docker run -ti --link elasticsearch-node01:elasticsearch -v /Users/PCAP:/pcap --name bro danielguerra/bro-debian-elasticsearch:develop /role/cmd-elasticsearch
```

### bro xinetd service
when role/xinetd is used no local logs are written, all logs go to elasticsearch
```bash
docker run -d -p 1969:1969 --link elasticsearch-master:elasticsearch --name bro-xinetd --hostname bro-xinetd danielguerra/bro-debian-elasticsearch /role/xinetd-elasticsearch
```
tcpdump to your container from a remote host, replace dockerhost with your ip
```bash
tcpdump -i eth0 -s 0 -w /dev/stdout | nc dockerhost 1969
```
or read a file file to your container
```bash
nc dockerhost 1969 < mydump.pcap
```

### bro xinetd forensic
when role/xinetd-forensic is used, pcap and extracted files are available from kibana.
```bash
docker run -d -p 1969:1969 -p 8080:80 --link elasticsearch-master:elasticsearch --name bro-xinetd-forensic --hostname bro-xinetd-forensic danielguerra/bro-debian-elasticsearch /role/xinetd-forensic
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

### bro amqp

Bro can be used with amqp in elasticsearch out or amqp output

First we need an amqp, this case a rabbitmq
```bash
docker run -d -p 8080:15672 --name=rabbitmq --hostname=rabbitmq rabbitmq:3.5.6-management
docker inspect rabbitmq (to get the ip)
```

Now we can start a bro xinetd service which outputs to rabbitmq
```bash
docker run -d -p 1970:1969 --name bro-xinetd-amqp --hostname bro-xinetd-amqp danielguerra/bro-debian-elasticsearch /role/xinetd-amqp

```

Or a bro that reads pcap files from amqp and outputs to amqp
```bash
docker run -d  --name=bro-amqp-amqp --hostname=bro-amqp-amqp danielguerra/bro-debian-elasticsearch /role/amqp-amqp <user> <pass> <ip> <queue> <user> <pass> <ip> <exchange>
```
And publish a pcap file from bro-dev commandline
```bash
cat <pcap-file> | amqp-publish   --url=amqp://<user>:<pass>@<amqp-ip> --exchange=<exchange>
```

### tcpdump containers

Start a bro-xinetd, do a (replace <container-to-dump> with your container name and <bro-xinetd-ip> with the bro xinetd ip)
```bash
docker run --rm  --net=container:<container-to-dump> crccheck/tcpdump -i eth0 -w - | nc <bro-xinetd-ip> 1969 &
docker run --rm  --net=container:<container-to-dump> danielguerra/bro-debian-elasticsearch:develop /role/dump-elasticsearch

```

### useful scripts

elastic-indices.sh shows elasticsearch indices
bro-mapping.sh bro mapping for kibana including geo_point mapping
remove-mapping.sh remove the mapping
clean-elastic.sh clean elasticsearch from bro data
update-intel.sh update intel for bro
