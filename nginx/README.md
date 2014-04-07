This is a sample Nginx config file to query ips

  $ ./start_nginx.sh

  $ curl -s "localhost:8080/?ip=177.205.166.201" | python -m json.tool
  {
      "data": {
          "as": "18881",
          "aspath": "18881",
          "nexthop": "200.219.138.113",
          "range": "177.205.160.0/20",
          "router": "201.7.183.65",
          "timestamp": "2014-03-28 16:00:13 -0300"
      },
      "status": "ok"
  }

