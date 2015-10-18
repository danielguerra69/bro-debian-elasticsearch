#!/usr/bin/python
#
#
import urllib

TOR_SERVERLIST_URL = "http://torstatus.blutmagie.de/ip_list_all.php/Tor_ip_list_ALL.csv"
SERVERS_FILE = "/tmp/tor_servers.txt"

servers = set()


def update_server_list():
    f = urllib.urlopen(TOR_SERVERLIST_URL)
    for server in f.readlines():
        servers.add(server.rstrip())
    f.close()


def write_server_list():
    if len(servers) < 1:
        sys.exit()

    sf = open(SERVERS_FILE, "w")
    sf.write("#fields\ttor_host\n")

    for server in servers:
        sf.write("%s\n" % server)

    sf.close()


def main():
    update_server_list()
    write_server_list()


if __name__ == "__main__":
    main()
