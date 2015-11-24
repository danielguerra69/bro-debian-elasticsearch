@load frameworks/intel/seen

redef Intel::read_files += {
  "/usr/local/bro/share/bro/custom/alienvault.intel",
  "/usr/local/bro/share/bro/custom/ciarmy.intel",
  "/usr/local/bro/share/bro/custom/malhosts.intel",
  "/usr/local/bro/share/bro/custom/mandiant.intel",
  "/usr/local/bro/share/bro/custom/snort.intel",
  "/usr/local/bro/share/bro/custom/botcc.intel",
  "/usr/local/bro/share/bro/custom/compromised.intel",
  "/usr/local/bro/share/bro/custom/malips.intel",
  "/usr/local/bro/share/bro/custom/tor.intel"
};
