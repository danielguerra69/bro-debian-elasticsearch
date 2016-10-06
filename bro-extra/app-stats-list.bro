module AppStats;

export {
	const hostnamestats_list: table[string] of string = {
	    [".facebook.com"] = "Facebook",
			[".fbcdn.net"] = "Facebook",
	    [".gmail.com"] = "Gmail",
	    [".youtube.com"] = "Youtube",
			[".googlevideo.com"] = "Youtube",
	    [".google.com"] = "Google",
	    [".netflix.com"] = "Netflix"
  } &redef;

  const certstats_list: table[string] of string = {
    ["^CN=www.[0-9a-zA-Z]+.(net|com)$"] = "Tor"
  } &redef;

}
