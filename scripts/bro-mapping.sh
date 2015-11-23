curl -XPUT elasticsearch:9200/_template/fixstrings_bro -d '{
  "template": "bro-*",
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
          "validation_status" : {
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
