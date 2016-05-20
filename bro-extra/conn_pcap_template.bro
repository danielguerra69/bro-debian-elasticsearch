
module Conn;

export {
        ## The default web server
        const webserver = "http://DOCKERHOST:6901/index.php?pcap_file=PCAPFILE" &redef;

        redef record Conn::Info += {
                ## Local filename of extracted file.
                pcapuri: string &optional &log;
        };

}

event connection_established(c: connection) &priority=5
        {
        local id = c$id;
        c$conn$pcapuri= cat(webserver,'&orig_h=',id$orig_h,'\&orig_p=',id$orig_p,'&orig_h=',id$resp_h,'&resp_p=',id$resp_p);
        }
