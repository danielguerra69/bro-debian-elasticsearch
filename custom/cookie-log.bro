module Cookie;

export {
  # The fully resolve name for this will be LocationExtract::LOG
  redef enum Log::ID += { LOG };
  type Info: record {
    ts:     time    &log;
    uid:    string &log;
    id:     conn_id  &log;
    cookie: string &log;
  };
}

global title_set: set[string];

event bro_init() &priority=5 {
  Log::create_stream(Cookie::LOG, [$columns=Info]);
}

event http_header(c: connection, is_orig: bool, name: string, value: string) &priority=2 {
  if ( is_orig && name == "COOKIE") {
    local log_rec: Cookie::Info = [$ts=network_time(), $uid=c$uid, $id=c$id, $cookie=value];
    Log::write(Cookie::LOG, log_rec);
  }
}
