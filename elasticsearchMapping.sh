curl -XPUT elasticsearch:9200/_template/fixstrings_bro -d '{
  "template": "bro-*",
    "mappings" : {
      "http" : {
        "properties" : {
          "host" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "id.orig_h" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "method" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "orig_fuids" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "orig_mime_types" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "proxied" : {
            "type" : "string"
          },
          "referrer" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "request_body_len" : {
            "type" : "long"
          },
          "resp_fuids" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "resp_mime_types" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "response_body_len" : {
            "type" : "long"
          },
          "status_code" : {
            "type" : "long"
          },
          "status_msg" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "tags" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "trans_depth" : {
            "type" : "long"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "uid" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "uri" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "user_agent" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "username" : {
            "type" : "string"
          }
        }
      },
      "known_hosts" : {
        "properties" : {
          "host" : {
            "type" : "string",
            "index" : "not_analyzed"
          }
        }
      },
      "tunnel" : {
        "properties" : {
          "action" : {
            "type" : "string"
          },
          "id.orig_h" : {
            "type" : "string"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "tunnel_type" : {
            "type" : "string"
          }
        }
      },
      "weird" : {
        "properties" : {
          "id.orig_h" : {
            "type" : "string"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "name" : {
            "type" : "string"
          },
          "notice" : {
            "type" : "boolean"
          },
          "peer" : {
            "type" : "string"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "uid" : {
            "type" : "string"
          }
        }
      },
      "ssl" : {
        "properties" : {
          "cert_chain_fuids" : {
            "type" : "string"
          },
          "cipher" : {
            "type" : "string"
          },
          "curve" : {
            "type" : "string"
          },
          "established" : {
            "type" : "boolean"
          },
          "id.orig_h" : {
            "type" : "string"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "issuer" : {
            "type" : "string"
          },
          "next_protocol" : {
            "type" : "string"
          },
          "resumed" : {
            "type" : "boolean"
          },
          "server_name" : {
            "type" : "string"
          },
          "subject" : {
            "type" : "string"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "uid" : {
            "type" : "string"
          },
          "validation_status" : {
            "type" : "string"
          },
          "version" : {
            "type" : "string"
          }
        }
      },
      "reporter" : {
        "properties" : {
          "level" : {
            "type" : "string"
          },
          "location" : {
            "type" : "string"
          },
          "message" : {
            "type" : "string"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          }
        }
      },
      "dns" : {
        "properties" : {
          "AA" : {
            "type" : "boolean"
          },
          "RA" : {
            "type" : "boolean"
          },
          "RD" : {
            "type" : "boolean"
          },
          "TC" : {
            "type" : "boolean"
          },
          "TTLs" : {
            "type" : "double"
          },
          "Z" : {
            "type" : "long"
          },
          "answers" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "id.orig_h" : {
            "type" : "string"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "proto" : {
            "type" : "string"
          },
          "qclass" : {
            "type" : "long"
          },
          "qclass_name" : {
            "type" : "string"
          },
          "qtype" : {
            "type" : "long"
          },
          "qtype_name" : {
            "type" : "string"
          },
          "query" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "rcode" : {
            "type" : "long"
          },
          "rcode_name" : {
            "type" : "string"
          },
          "rejected" : {
            "type" : "boolean"
          },
          "trans_id" : {
            "type" : "long"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "uid" : {
            "type" : "string"
          }
        }
      },
      "x509" : {
        "properties" : {
          "basic_constraints.ca" : {
            "type" : "boolean"
          },
          "basic_constraints.path_len" : {
            "type" : "long"
          },
          "certificate.curve" : {
            "type" : "string"
          },
          "certificate.exponent" : {
            "type" : "string"
          },
          "certificate.issuer" : {
            "type" : "string"
          },
          "certificate.key_alg" : {
            "type" : "string"
          },
          "certificate.key_length" : {
            "type" : "long"
          },
          "certificate.key_type" : {
            "type" : "string"
          },
          "certificate.not_valid_after" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "certificate.not_valid_before" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "certificate.serial" : {
            "type" : "string"
          },
          "certificate.sig_alg" : {
            "type" : "string"
          },
          "certificate.subject" : {
            "type" : "string"
          },
          "certificate.version" : {
            "type" : "long"
          },
          "id" : {
            "type" : "string"
          },
          "san.dns" : {
            "type" : "string"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          }
        }
      },
      "cookie" : {
        "properties" : {
          "cookie" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "cookie_vars" : {
            "type" : "string"
          },
          "id.orig_h" : {
            "type" : "string"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "uid" : {
            "type" : "string"
          }
        }
      },
      "notice" : {
        "properties" : {
          "actions" : {
            "type" : "string"
          },
          "dropped" : {
            "type" : "boolean"
          },
          "dst" : {
            "type" : "string"
          },
          "id.orig_h" : {
            "type" : "string"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "msg" : {
            "type" : "string"
          },
          "note" : {
            "type" : "string"
          },
          "p" : {
            "type" : "long"
          },
          "peer_descr" : {
            "type" : "string"
          },
          "proto" : {
            "type" : "string"
          },
          "src" : {
            "type" : "string"
          },
          "sub" : {
            "type" : "string"
          },
          "suppress_for" : {
            "type" : "double"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "uid" : {
            "type" : "string"
          }
        }
      },
      "files" : {
        "properties" : {
          "analyzers" : {
            "type" : "string"
          },
          "conn_uids" : {
            "type" : "string"
          },
          "depth" : {
            "type" : "long"
          },
          "duration" : {
            "type" : "double"
          },
          "fuid" : {
            "type" : "string"
          },
          "is_orig" : {
            "type" : "boolean"
          },
          "md5" : {
            "type" : "string"
          },
          "mime_type" : {
            "type" : "string"
          },
          "missing_bytes" : {
            "type" : "long"
          },
          "overflow_bytes" : {
            "type" : "long"
          },
          "rx_hosts" : {
            "type" : "string"
          },
          "seen_bytes" : {
            "type" : "long"
          },
          "sha1" : {
            "type" : "string"
          },
          "source" : {
            "type" : "string"
          },
          "timedout" : {
            "type" : "boolean"
          },
          "total_bytes" : {
            "type" : "long"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "tx_hosts" : {
            "type" : "string"
          }
        }
      },
      "location": {
        "properties" : {
          "uid" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "origin" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "ext_location" : {
            "type" : "geo_point"
          }
        }
      },
      "conn" : {
        "properties" : {
          "conn_state" : {
            "type" : "string"
          },
          "duration" : {
            "type" : "double"
          },
          "history" : {
            "type" : "string"
          },
          "id.orig_h" : {
            "type" : "string"
          },
          "id.orig_p" : {
            "type" : "long"
          },
          "id.resp_h" : {
            "type" : "string"
          },
          "id.resp_p" : {
            "type" : "long"
          },
          "orig_location" : {
            "type" : "geo_point"
          },
          "resp_location" : {
            "type" : "geo_point"
          },
          "missed_bytes" : {
            "type" : "long"
          },
          "orig_bytes" : {
            "type" : "long"
          },
          "orig_ip_bytes" : {
            "type" : "long"
          },
          "orig_pkts" : {
            "type" : "long"
          },
          "proto" : {
            "type" : "string"
          },
          "resp_bytes" : {
            "type" : "long"
          },
          "resp_ip_bytes" : {
            "type" : "long"
          },
          "resp_loc" : {
            "type" : "string"
          },
          "resp_pkts" : {
            "type" : "long"
          },
          "service" : {
            "type" : "string"
          },
          "ts" : {
            "type" : "date",
            "format" : "dateOptionalTime"
          },
          "uid" : {
            "type" : "string"
          }
        }
      }
    }
  }'
