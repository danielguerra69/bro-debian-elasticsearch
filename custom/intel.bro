@load frameworks/intel/seen

redef Intel::read_files += {
  "/usr/local/bro/share/bro/bro-extra/alienvault.intel",
  "/usr/local/bro/share/bro/bro-extra/ciarmy.intel",
  "/usr/local/bro/share/bro/bro-extra/malhosts.intel",
  "/usr/local/bro/share/bro/bro-extra/mandiant.intel",
  "/usr/local/bro/share/bro/bro-extra/snort.intel",
  "/usr/local/bro/share/bro/bro-extra/botcc.intel",
  "/usr/local/bro/share/bro/bro-extra/compromised.intel",
  "/usr/local/bro/share/bro/bro-extra/malips.intel",
  "/usr/local/bro/share/bro/bro-extra/tor.intel"
};
