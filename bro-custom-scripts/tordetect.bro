module DetectTor;

event ssl_established(c: connection ) &priority=6
        {
                if ( c$ssl?$subject && /^CN=www.[0-9a-zA-Z]+.(net|com)$/ == c$ssl$subject && c$ssl?$issuer && /^CN=www.[0-9a-zA-Z]+.(com|net)$/ == c$ssl$issuer )
                        {
                                add c$service["tor"];
                        }
        }
