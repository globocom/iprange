#!/usr/bin/ruby
$:.unshift File.expand_path("../../lib", __FILE__)
require 'iprange'
require 'mysql2'
require 'redis'

mysql_config = {
}

redis_config = {}

LAST_UPDATE_TIME_KEY = 'last_update_time'

def update(mysql, redis_config)
  range = IPRange::Range.new(redis_config)
  redis = Redis.new(redis_config)
  last_update_time = redis.get(LAST_UPDATE_TIME_KEY)

  sql =  "SELECT prefix, originas, nexthop, time from prefixes"
  sql += " WHERE time >= '#{last_update_time}'" if last_update_time
  sql += " ORDER BY time"

  results = mysql.query(sql)
  puts "#{results.count} prefixes found since '#{last_update_time}'"
  results.each_with_index do |row, i|
    range.add row["prefix"], {as: row["originas"], nexthop: row["nexthop"]}
    if ((i + 1) % 10000) == 0
      puts "10000 rows added"
      redis.set(LAST_UPDATE_TIME_KEY, row['time'])
    end
  end
end

begin
  mysql = Mysql2::Client.new mysql_config
  update mysql, redis_config
rescue Exception => e
  puts e.message
  puts e.backtrace.inspect
else
  puts "Done!"
ensure
  mysql.close if mysql
end
