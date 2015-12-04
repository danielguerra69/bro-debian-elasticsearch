#!/bin/bash
# Usage bro-amqp.sh USER PASS HOST EXCHANGE
bro -r - | amqp-publish  -l --url=amqp://$1:$2@$3 --exchange=$4
