#!/bin/bash
# Usage bro-forensic.sh  DOCKERHOST

#file extraction
export DOCKERHOST=$1
cp /usr/local/bro/share/bro/bro-extra/extract_files_template.bro /usr/local/bro/share/bro/bro-extra/extract_files.bro
sed -i "s/DOCKERHOST/$DOCKERHOST/" /usr/local/bro/share/bro/bro-extra/extract_files.bro

#pcap
PCAPFILE=`tempfile -d /bro/pcap -p bro- -s .pcap`
cp /usr/local/bro/share/bro/bro-extra/conn_pcap_template.bro /usr/local/bro/share/bro/bro-extra/conn_pcap.bro
sed -i "s/PCAPFILE/$PCAPFILE/" /usr/local/bro/share/bro/bro-extra/conn_pcap.bro
sed -i "s/DOCKERHOST/$DOCKERHOST/" /usr/local/bro/share/bro/bro-extra/conn_pcap.bro
#cmd
tee -a $PCAPFILE | bro -r -
