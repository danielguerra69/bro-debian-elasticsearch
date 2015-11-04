##! Add geo_location for the originator and responder of a connection
##! to the connection logs.

module Conn;

export
{
        redef record Conn::Info +=
        {
                geo_location: string &optional &log;
        };
}

event connection_state_remove(c: connection)
{
        local resp_loc = lookup_location(c$id$resp_h);
        if (resp_loc?$longitude && resp_loc?$latitude)
          c$conn$geo_location= cat(resp_loc$latitude,",",resp_loc$longitude);
}
