service bro
{
        socket_type     = stream
        wait            = no
        user            = root
        group           = root
        server          = /usr/local/bro/bin/bro
        server_args	    = -r -
        instances       = 300
}
