module Location;

@load base/utils/exec

 export {
     	# The fully resolve name for this will be Location::LOG
     	redef enum Log::ID += { LOG };

	type GeoHash: record {
    		location: string;
	};

     	type Info: record {
         	ts:    	  time    &log;
         	uid:   	  string  &log;
          origin: 	string  &log;
         	pin: 	    GeoHash &log;
     	};
#     redef exit_only_after_terminate=T;
 }

 global title_set: set[string];

 event bro_init() &priority=5
 	{
     	Log::create_stream(Location::LOG, [$columns=Info]);
	}

 event http_request(c: connection, method: string, original_URI: string, unescaped_URI: string, version: string)
      {

				local location_extracted: geo_location;
				local origin: string;
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
							location_extracted = [$latitude=to_double(latitude[1]),$longitude=to_double(longitude[1])];
						}
                    		}
				# look for dutch coordinate pairs
				else if ( /5[2345][.][0-9]+[,][34567][.][0-9]+/ in unescaped_URI)
				{
					local coordinatestring = find_last(unescaped_URI,/(5[2345][.][0-9]+[,][34567][.][0-9]+)/);
					local coordinate = split_string1(coordinatestring,/,/);
					if (1 in coordinate && to_double(coordinate[0]) != 0)
					{
						origin = "uri_pair";
						location_extracted = [$latitude=to_double(coordinate[0]),$longitude=to_double(coordinate[1])];
					}
				}
				# just look for a dutch coordinate at least 3 digit precision
				else if ( /=5[2345][.][0-9]{3,}/ in unescaped_URI && /=[34567][.][0-9]{3,}/ in unescaped_URI)
				{
					latstring = find_last(unescaped_URI,/=(5[2345][.][0-9]{3,})/);
					latitude = split_string1(latstring,/=/);
					longstring = find_last(unescaped_URI,/=([34567][.][0-9]{3,})/);
					longitude = split_string1(longstring,/=/);
					if ( 1 in latitude && 1 in longitude  && to_double(latitude[1]) != 0)
					{
						origin = "uri_digi";
						location_extracted = [$latitude=to_double(latitude[1]),$longitude=to_double(longitude[1])];
					}
				}
				if (location_extracted?$latitude) {
				#	local anagram : Exec::Command;
				#	local prog = cat ("/usr/local/bro/share/bro/custom/bin/geohash.py ",location_extracted$latitude," ",location_extracted$longitude);
					#print prog;
				#	anagram = [$cmd = prog];
				#	when (local res = Exec::run(anagram) )
				#	{
				#		if (res?$stdout) {
							local coordinates : GeoHash;
							local coords = cat(location_extracted$latitude,",",location_extracted$longitude);
							coordinates = [$location=coords];
							local log_rec: Location::Info = [$ts=network_time(), $uid=c$uid, $origin=origin , $pin=coordinates];
							Log::write(Location::LOG, log_rec);
				#		}
				#	}
				}
      }
