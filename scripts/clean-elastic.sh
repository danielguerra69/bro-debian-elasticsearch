#!/bin/bash
for x in `curl --silent 'elasticsearch:9200/_cat/indices?v' | sed '1d'| grep -e bro-| cut -d " " -f 5`; do echo $x; curl -XDELETE 'http://elasticsearch:9200/'$x; done
