##! AppStats collects information about web applications in use
##! on the network.

@load base/protocols/http
@load base/protocols/ssl
@load base/protocols/dns
@load base/frameworks/sumstats
@load ./app-stats-list

module AppStats;

export {
        redef enum Log::ID += { LOG };

        type Info: record {
                ## Timestamp when the log line was finished and written.
                ts:         time   &log;
                ## Time interval that the log line covers.
                ts_delta:   interval &log;
                ## The name of the "app", like "facebook" or "netflix".
                app:        string &log;
                ## The number of unique local hosts using the app.
                uniq_hosts: count  &log;
                ## The number of hits to the app in total.
                hits:       count  &log;
                ## The total number of bytes received by users of the app.
                bytes:      count  &log;
        };

        redef record Conn::Info += {
                ## add response hostname to connection
                resp_hostname: string &optional &log;
        };
        ## The frequency of logging the stats collected by this script.
        const break_interval = 15mins &redef;
}

global add_sumstats: hook(id: conn_id, hostname: string, size: count);

global add_urlsumstats: hook(id: conn_id, hostname: string, size: count);

event bro_init() &priority=3
        {
        Log::create_stream(AppStats::LOG, [$columns=Info, $path="app_stats"]);

        local r1: SumStats::Reducer = [$stream="apps.bytes", $apply=set(SumStats::SUM)];
        local r2: SumStats::Reducer = [$stream="apps.hits",  $apply=set(SumStats::UNIQUE)];
        SumStats::create([$name="app-metrics",
                          $epoch=break_interval,
                          $reducers=set(r1, r2),
                          $epoch_result(ts: time, key: SumStats::Key, result: SumStats::Result) =
                                {
                                local l: Info;
                                l$ts         = network_time();
                                l$ts_delta   = break_interval;
                                l$app        = key$str;
                                l$bytes      = double_to_count(floor(result["apps.bytes"]$sum));
                                l$hits       = result["apps.hits"]$num;
                                l$uniq_hosts = result["apps.hits"]$unique;
                                Log::write(LOG, l);
                                }]);
          }

  event connection_state_remove (c: connection)
          {
            #check uri if there is one
            if ( c?$http && c$http?$uri )
              hook add_urlsumstats(c$id, c$http$uri, c$resp$size+c$orig$size);

            # names first try dns otherwise ssl server or http  and set resp_hostname
            if ( c?$dns && c$dns?$query )
                c$conn$resp_hostname=c$dns$query ;
            else if ( c?$ssl && c$ssl?$server_name )
                c$conn$resp_hostname=c$ssl$server_name;
            else if ( c?$http && c$http?$host )
                        c$conn$resp_hostname=c$http$host;
            else
              return;
            # check if there is a name
            hook add_sumstats(c$id, c$conn$resp_hostname, c$resp$size+c$orig$size);
          }

  hook add_sumstats(id: conn_id, hostname: string, size: count)
        {
        for ( i in appstats_list )
          {
          if ( appstats_list[i] in hostname && size > 20 )
                  {
                  SumStats::observe("apps.bytes", [$str=cat(i)], [$num=size]);
                  SumStats::observe("apps.hits",  [$str=cat(i)], [$str=cat(id$resp_h)]);
                  }
          }
        }

  hook add_urlsumstats(id: conn_id, uri: string, size: count)
        {
        for ( i in urlappstats_list )
          {
          if ( urlappstats_list[i] in uri && size > 20 )
                  {
                  SumStats::observe("apps.bytes", [$str=cat(i)], [$num=size]);
                  SumStats::observe("apps.hits",  [$str=cat(i)], [$str=cat(id$resp_h)]);
                  }
          }
        }
