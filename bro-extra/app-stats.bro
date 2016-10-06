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

global dns_answers: table[addr] of string;

global ssl_hosts: table[addr] of string;

global http_hosts: table[addr] of string;

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

  event dns_A_reply(c: connection, msg: dns_msg, ans: dns_answer, a: addr)
          {
            if ( ans?$query )
              dns_answers[a]=ans$query;
          }

  event dns_A6_reply(c: connection, msg: dns_msg, ans: dns_answer, a: addr)
          {
            if ( ans?$query )
              dns_answers[a]=ans$query;
          }


  event ssl_established(c: connection)
          {
            if ( c?$ssl  )
              {
                if ( c$ssl?$server_name )
                      ssl_hosts[c$id$resp_h] = c$ssl$server_name;
              }
          }

  event HTTP::log_http(rec: HTTP::Info)
          {
          if ( rec?$host )
              http_hosts[rec$id$resp_h]=rec$host;
          }

  event connection_state_remove (c: connection)
          {

            if ( c$id$resp_h in dns_answers )
                c$conn$resp_hostname=dns_answers[c$id$resp_h];
            else if ( c$id$resp_h in ssl_hosts )
                c$conn$resp_hostname=ssl_hosts[c$id$resp_h];
            else if ( c$id$resp_h in http_hosts )
                c$conn$resp_hostname=http_hosts[c$id$resp_h];
            else
              return;

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
