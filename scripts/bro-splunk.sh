#!/bin/bash
# Usage bro-splunk.sh HOST PORT
bro -r - | curl -K http://$1:$2
