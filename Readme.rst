#### BRO ELK docker integration

### elastic data
volume with mapping and kibana vieuws

docker create -v /usr/share/elasticsearch/data --name elastic-data danielguerra/bro-elasticsearch-kibana-volume /bin/true

### elasticsearch

docker run -d -p 9200:9200 -p 9300:9300 --volumes-from elastic-data --hostname=elasticsearch  --name elasticsearch elasticsearch:1.7

### kibana

docker run -d -p 5601:5601 --link=elasticsearch:elasticsearch --hostname=kibana --name kibana million12/kibana4 --elasticsearch http://elasticsearch:9200

### start bro on the commandline
docker run -ti --link elasticsearch:elasticsearch -v /Users/PCAP:/pcap --name bro-dev danielguerra/bro-debian-elasticsearch /bin/bash
readfiles from bro-dev commandline
bro -r /pcap/mydump.pcap

### bro xinetd service
docker run -d -p 1969:1969 --link elasticsearch:elasticsearch --volumes-from ssh-container -v /Users/PCAP:/pcap --name bro-xinetd --hostname bro-xinetd danielguerra/bro-debian-elasticsearch /usr/sbin/xinetd -dontfork
tcpdump to your container from a remote host, replace dockerhost with your ip
tcpdump -i eth0 -s 0 -w /dev/stdout | nc dockerhost 1969
or read a file file to your container
nc dockerhost 1969 < mydump.pcap

###bro ssh server
for bro nodes or just remote key based authentication
create an empty ssh volume
docker create -v /root/.ssh --name ssh-container danielguerra/ssh-container /bin/true
create your own keys on your own machine
docker run --volumes-from ssh-container debian:jessie ssh-keygen -q
add your pub key to authorized_keys file
docker run --volumes-from ssh-container debian:jessie cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
create a copy in your directory (pwd)
docker run --volumes-from ssh-container -v $(pwd):/backup debian:jessie cp -R /root/.ssh/* /backup
start bro as deamon
docker run -d -p 1922:22 --link elasticsearch:elasticsearch --name bro-dev danielguerra/bro-debian-elasticsearch
ssh -p 1922 -i id_rsa root@dockerhost

### useful scripts
elasticsearchMapping.sh bro mapping for kibana including geo_point mapping
removeMapping.sh remove the mapping
cleanelastic.sh clean elasticsearch from bro data
updateintel.sh update intel for bro
