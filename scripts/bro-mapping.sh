#!/bin/bash
until curl -XGET elasticsearch:9200/; do
  >&2 echo "Elasticsearch is unavailable - sleeping"
  sleep 5
done

>&2 echo "Elasticsearch is up - executing command"
curl -XPUT elasticsearch:9200/_template/fixstrings_bro -d '{
  "template": "bro-*",
    "index": {
      "number_of_shards": 7,
      "number_of_replicas": 1
    },
    "mappings" : {
      "http" : {
        "properties" : {
          "status_msg" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "user_agent" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "uri" : {
            "type" : "string",
            "index" : "not_analyzed"
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
      "files" : {
        "properties" : {
          "mime_type" : {
            "type" : "string",
            "index" : "not_analyzed"
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
      "notice" : {
        "properties" : {
          "note" : {
            "type" : "string",
            "index" : "not_analyzed"
          }
        }
      },
      "ssl" : {
        "properties" : {
          "validation_status" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "server_name" : {
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
      },
      "intel" : {
        "properties" : {
          "sources" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "seen_indicator_type" : {
            "type" : "string",
            "index" : "not_analyzed"
          },
          "seen_where" : {
            "type" : "string",
            "index" : "not_analyzed"
          }
        }
      },
      "weird" : {
        "properties" : {
          "name" : {
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
