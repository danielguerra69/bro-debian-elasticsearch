const broker_port: port = 9999/tcp &redef;
redef BrokerComm::endpoint_name = "events";
export {
        global bro_packet: event(p: pkt_hdr);
}
event bro_init()
        {
        BrokerComm::enable();
        BrokerComm::listen(broker_port, "127.0.0.1");
        BrokerComm::auto_event("bro/event/bro_packet", bro_packet);
        }
event new_packet(c:connection, p: pkt_hdr) { event bro_packet(p); }
