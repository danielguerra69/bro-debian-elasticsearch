#!/bin/bash
cd /tmp
# mayhemic is offline ??
mal-dnssearch -M mayhemic -p | mal-dns2bro -n true -T dns -s mayhemic-mallware > /usr/local/bro/share/bro/site/bro-extra/mayhemic.intel
mal-dnssearch -M ciarmy -p | mal-dns2bro -n true -T ip -s ciarmy-badguys > /usr/local/bro/share/bro/site/bro-extra/ciarmy.intel
mal-dnssearch -M malips -p | mal-dns2bro -n true -T ip -s malips > /usr/local/bro/share/bro/site/bro-extra/malips.intel
mal-dnssearch -M botcc -p | mal-dns2bro -n true -T ip -s botcc-troyan > /usr/local/bro/share/bro/site/bro-extra/botcc.intel
mal-dnssearch -M malhosts -p | mal-dns2bro -n true -T dns -s malhosts-dns > /usr/local/bro/share/bro/site/bro-extra/malhosts.intel
mal-dnssearch -M mandiant -p | mal-dns2bro -n true -T dns -s mandiant-mal-dns > /usr/local/bro/share/bro/site/bro-extra/mandiant.intel
mal-dnssearch -M snort -p | mal-dns2bro -n true -T ip -s snort-ip-filter > /usr/local/bro/share/bro/site/bro-extra/snort.intel
mal-dnssearch -M alienvault -p | mal-dns2bro -n true -T ip -s alienvault-scanhost > /usr/local/bro/share/bro/site/bro-extra/alienvault.intel
mal-dnssearch -M et_ips -p | mal-dns2bro -T ip -n true -s et_ps_compromised > /usr/local/bro/share/bro/site/bro-extra/compromised.intel
mal-dnssearch -M snort -p | mal-dns2bro -T ip -s snort-ip-filter > /usr/local/bro/share/bro/site/bro-extra/snort.intel
/usr/bin/python /scripts/update_tor_serverlist.py && mal-dns2bro -T ip -n true -f /tmp/tor_servers.txt -s tor-server > /usr/local/bro/share/bro/site/bro-extra/tor.intel
