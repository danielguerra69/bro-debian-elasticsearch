BRO ELK docker

( docker-machine -D create -d virtualbox docker)
(docker-machine ssh docker)

elasticsearch
(data is the dir you store the data)

docker run -d -p 9200:9200 -p 9300:9300 -v data:/usr/share/elasticsearch/data --hostname=elasticsearch  --name elasticsearch elasticsearch


kibana
(cutting edge with map)
docker run -d -p 5601:5601 --link=elasticsearch:elasticsearch --hostname=kibana --name kibana million12/kibana4 --elasticsearch http://elasticsearch:9200

(or without map)
docker run -d -p 5601:5601 --link=elasticsearch:elasticsearch -e ELASTICSEARCH=http://elasticsearch:9200 --hostname=kibana --name kibana kibana

bro
docker run -ti --link elasticsearch:elasticsearch -v /Users/data:/data --name bro-dev danielguerra/bro-debian-elasticsearch

get indices from elasticsearch
(in bro-dev bash)

curl ‘elasticsearch:9200/_cat/indices?v'

delete indices

curl -XDELETE 'http://elasticsearch:9200/bro-201304260900'

TODO
[] location in kibana
