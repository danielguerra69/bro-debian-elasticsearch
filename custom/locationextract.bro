module Location;

@load base/utils/exec

export
{
     	redef enum Log::ID += { LOG };

     	type Info: record
      {
         	ts:    	      time    &log;
         	uid:   	      string  &log;
          origin: 	    string  &log;
         	ext_location: string &log;
     	};
}

global title_set: set[string];

event bro_init() &priority=5
{
  Log::create_stream(Location::LOG, [$columns=Info]);
}

event http_request(c: connection, method: string, original_URI: string, unescaped_URI: string, version: string)
{
  local origin: string;
  local location_extracted: string="";
	#look for the word long and lat
  if (  /lati?t?u?d?e?=([0-9]{1,2}[.][0-9]+)/ in unescaped_URI && /lo?ngi?t?u?d?e?=([0-9]{1,3}[.][0-9]+)/ in unescaped_URI )
  {
    local latstring = find_last(unescaped_URI,/lati?t?u?d?e?=([0-9]{1,2}[.][0-9]+)/);
    local latitude = split_string1(latstring,/=/);
    local longstring = find_last(unescaped_URI,/lo?ngi?t?u?d?e?=([0-9]{1,3}[.][0-9]+)/);
    local longitude = split_string1(longstring,/=/);
    if ( 1 in latitude && 1 in longitude  && to_double(latitude[1]) != 0)
    {
      origin = "uri_name";
      location_extracted = cat(latitude[1],",",longitude[1]);
    }                		}
    # look for coordinate pairs
    else if ( /=[0-8]?[0-9][.][0-9]{3,}[,][1]?[0-9]?[0-9][.][0-9]{3,}/ in unescaped_URI)
    {
    	local coordinatestring = find_last(unescaped_URI,/=([0-8]?[0-9][.][0-9]{3,}[,][1]?[0-9]?[0-9][.][0-9]{3,})/);
      local cleanstring = split_string1(coordinatestring,/=/);
    	local coordinate = split_string1(cleanstring[1],/,/);
    	if (1 in coordinate && to_double(coordinate[0]) != 0)
    	{
    		origin = "uri_pair";
    		location_extracted = cat(coordinate[0],",",coordinate[1]);
    	}
    }
    if (location_extracted != "") {
    			local log_rec: Location::Info = [$ts=network_time(), $uid=c$uid, $origin=origin , $ext_location=location_extracted];
    			Log::write(Location::LOG, log_rec);
    }
}
