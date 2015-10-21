#!/usr/bin/env python
from select import select
import pybroker

def get_fields(fields, n_fields):
    new_fields = []
    for n in range(n_fields):
        f = fields[n]
        if f.valid():
            new_fields.append(f.get())
        else:
            new_fields.append(None)
    return new_fields

def ppkt(p):
    rec = p.as_record()
    rec = ip.as_record()
    fields = rec.fields()
	fields = rec.fields()
    fields = [f for f in fields]
    print fields

def pmsg(msg_type, obj):
    msg_type = msg_type.as_string()
    pobj = {
        "bro_packet": ppkt,
    }[msg_type]
    # print "%s: " % msg_type,
    pobj(obj)

def main():
    epc = pybroker.endpoint("connector")
    epc.peer("127.0.0.1", 9999, 1)
    ocsq = epc.outgoing_connection_status()
    select([ocsq.fd()], [], [])
    conns = ocsq.want_pop()
    for m in conns:
        print("outgoing connection", m.peer_name, m.status)

    mql = pybroker.message_queue("bro/event", epc)

    while True:
        select([mql.fd()], [], [])
        msgs = mql.want_pop()
        for m in msgs:
            pmsg(*m)

main()
