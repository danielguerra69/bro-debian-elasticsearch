##! This script can be used to extract either the originator's data or the 
##! responders data or both.  By default nothing is extracted, and in order
##! to actually extract data the ``c$extract_orig`` and/or the
##! ``c$extract_resp`` variable must be set to ``T``.  One way to achieve this
##! would be to handle the :bro:id:`connection_established` event elsewhere
##! and set the ``extract_orig`` and ``extract_resp`` options there.
##! However, there may be trouble with the timing due to event queue delay.
##!
##! .. note::
##!
##!    This script does not work well in a cluster context unless it has a
##!    remotely mounted disk to write the content files to.

@load base/utils/files

module Conn;

export {
	## The prefix given to files containing extracted connections as they
	## are opened on disk.

	const extraction_prefix = "contents" &redef;

	## If this variable is set to ``T``, then all contents of all
	## connections will be extracted.
	const default_extract = T;

	const extraction_dir = "./extract_files/";

}

function generate_extraction_filename2(dir: string, prefix: string, c: connection, suffix: string): string
	{
	local conn_info = fmt("%s:%d-%s:%d",
	                      c$id$orig_h, c$id$orig_p, c$id$resp_h, c$id$resp_p);

	if ( prefix != "" )
		conn_info = fmt("%s_%s", prefix, conn_info);
	if ( suffix != "" )
		conn_info = fmt("%s_%s", conn_info, suffix);

	if ( dir != "" )
		conn_info = fmt("%s/%s/%s/%s", dir, c$id$orig_h, c$id$resp_h, conn_info);

	return conn_info;
	}

function mkdirs(dir: string): bool {
	local path_split = split1(dir, /\/[^\/]*$/);
	local parent = path_split[1];

	if ( parent == "" || |path_split| == 1 )
		return mkdir(dir);
	else {
		if ( ! mkdirs(parent) )
			return F;
		return mkdir(dir);
	}

	return T;
}

function path_dirname(path: string): string {
	#return path_split(path)[1]
	return split1(path, /\/[^\/]*$/)[1];
}

function path_filename(path: string): string {
	#return path_split(path)[2]
	local cpath = split(path, /\//);
	return cpath[|cpath|];
}

function path_split(path: string): string_array {
	local cpath = split(path, /\//);
	local ret_val: string_array;

	ret_val[2] = cpath[|cpath|];
	delete cpath[|cpath|];
	ret_val[1] = join_string_array("/", cpath);

	return ret_val;
}

redef record connection += {
	extract_orig: bool &default=default_extract;
	extract_resp: bool &default=default_extract;
};

event connection_established(c: connection) &priority=-5
	{

	if ( c$extract_orig )
		{
		local orig_file =  fmt("%s/%s.%s", extraction_dir, c$uid, "orig.dat");
		mkdir(extraction_dir);
		local orig_f = open(orig_file);
		set_contents_file(c$id, CONTENTS_ORIG, orig_f);
		}

	if ( c$extract_resp )
		{
		local resp_file = fmt("%s/%s.%s", extraction_dir, c$uid, "resp.dat");
		mkdir(extraction_dir);
		local resp_f = open(resp_file);
		set_contents_file(c$id, CONTENTS_RESP, resp_f);
		}
	}
