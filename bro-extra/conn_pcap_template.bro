
module PcapConn;

export {
        ## The default web server
        const webserver = "http://DOCKERHOST/index.php?pcap_file=PCAPFILE" &redef;

        redef record Conn::Info += {
                ## Local filename of extracted file.
                pcapuri: string &optional &log;
        };

}

event connection_state_remove(c: connection)
        {
        local id = c$id;
        c$conn$pcapuri= escape_string( cat( webserver,"&proto=",get_port_transport_proto(id$orig_p),"&orig_h=",id$orig_h,"&orig_p=",port_to_count(id$orig_p),"&resp_h=",id$resp_h,"&resp_p=",port_to_count(id$resp_p)));
        }
