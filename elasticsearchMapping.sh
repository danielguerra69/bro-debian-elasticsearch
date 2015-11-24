curl -XPUT elasticsearch:9200/_template/fixstrings_bro -d '{
  "template": "bro-*",
    "mappings" : {
      "http" : {
        "properties" : {
          "host" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "id_orig_h" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "id_orig_p" : {
            "type" : "long"
          },
          "id_resp_h" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "id_resp_p" : {
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
        "conn" : {
          "properties" : {
            "orig_location" : {
              "type" : "geo_point"
            },
            "resp_location" : {
              "type" : "geo_point"
            }
          }
      },
      "location": {
        "properties" : {
          "ext_location" : {
            "type" : "geo_point"
          }
        }
      },
      "ssl" : {
        "properties" : {
          "resumed" : {
            "type" : "boolean"
          },
          "validation_status" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "version" : {
            "type" : "string",
            "index" : "not_analyzed"
          }
        }
      },
      "dns" : {
        "properties" : {
          "answers" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "query" : {
            "type" : "string",
            "index" : "not_analyzed"
          }
        }
      }
    }
  }'
