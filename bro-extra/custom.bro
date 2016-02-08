# This script loads tcprs reordering
#@load ./tcprs
# This script add lat long to ip numbers in orig_loc and dest_loc
@load ./geoip

# This script extracts cookies from http data
@load ./cookie-log

# This script loads the signature framework
@load base/frameworks/signatures/main

# probebly dont need this
@load base/frameworks/notice/actions/add-geodata

# This script adds various sources of intel with mal-dns see update-intel.sh
@load ./intel

# This script detects tor traffic
@load ./tordetect

# This script extracts certificates
@load policy/protocols/ssl/extract-certs-pem

# This script extracts locations from http uri's
@load ./locationextract

# This script logs which scripts were loaded during each run.
@load misc/loaded-scripts

# Apply the default tuning scripts for common tuning settings.
@load tuning/defaults

# Load the scan detection script.
@load misc/scan

# Log some information about web applications being used by users
# on your network.
@load misc/app-stats

# Detect traceroute being run on the network.
@load misc/detect-traceroute

# Generate notices when vulnerable versions of software are discovered.
# The default is to only monitor software found in the address space defined
# as "local".  Refer to the software framework's documentation for more
# information.
@load policy/frameworks/software/vulnerable

# Detect software changing (e.g. attacker installing hacked SSHD).
@load policy/frameworks/software/version-changes

# Load all of the scripts that detect software in various protocols.
@load policy/protocols/ftp/software
@load policy/protocols/smtp/software
@load policy/protocols/ssh/software
@load policy/protocols/http/software
# The detect-webapps script could possibly cause performance trouble when
# running on live traffic.  Enable it cautiously.
#@load protocols/http/detect-webapps

# This script detects DNS results pointing toward your Site::local_nets
# where the name is not part of your local DNS zone and is being hosted
# externally.  Requires that the Site::local_zones variable is defined.
@load policy/protocols/dns/detect-external-names

# Script to detect various activity in FTP sessions.
@load policy/protocols/ftp/detect

# Scripts that do asset tracking.
@load policy/protocols/conn/known-hosts
@load policy/protocols/conn/known-services
@load policy/protocols/ssl/known-certs

# This script enables SSL/TLS certificate validation.
@load policy/protocols/ssl/validate-certs

# This script prevents the logging of SSL CA certificates in x509.log
@load policy/protocols/ssl/log-hostcerts-only

# Uncomment the following line to check each SSL certificate hash against the ICSI
# certificate notary service; see http://notary.icsi.berkeley.edu .
@load policy/protocols/ssl/notary

# Detect hosts doing SSH bruteforce attacks.
@load policy/protocols/ssh/detect-bruteforcing
# Detect logins using "interesting" hostnames.
@load policy/protocols/ssh/interesting-hostnames

# Detect SQL injection attacks.
@load policy/protocols/http/detect-sqli

#### Network File Handling ####

# Enable MD5 and SHA1 hashing for all files.
@load policy/frameworks/files/hash-all-files

# Detect SHA1 sums in Team Cymru's Malware Hash Registry.
@load policy/frameworks/files/detect-MHR

# Uncomment the following line to enable detection of the heartbleed attack. Enabling
# this might impact performance a bit.
@load policy/protocols/ssl/heartbleed
