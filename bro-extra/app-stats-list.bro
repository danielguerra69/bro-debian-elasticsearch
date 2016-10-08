module AppStats;

export {

	const appstats_list: table[string] of pattern = {
	    ["Facebook"] = /.facebook.com$|.fbcdn.net$/,
	    ["Gmail"] = /.gmail.com$/,
	    ["Youtube"] = /.youtube.com$|.googlevideo.com$/,
	    ["Google"] =  /.google.com$/,
	    ["Netflix"] = /.netflix.com$|.nflxvideo.net$/,
			["Tor"] = /^www.[0-9a-zA-Z]+.(net|com)$/
  } &redef;

	const urlappstats_list: table[string] of pattern = {
			["Tor"] = /^\/tor\//
	} &redef;
}
