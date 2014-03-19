require "iprange/version"
require "redis"
require "ipaddr"

module IPRange
  class Range
    def initialize(redis_config={}, redis_key="ip_table")
      @redis = Redis.new redis_config
      @redis_key = redis_key
    end

    def add(range)
      end_ip = IPAddr.new(range).to_range.last.to_i
      @redis.zadd(@redis_key, end_ip, range)
    end

    def find(ip)
      ipaddr = IPAddr.new(ip)
      next_range = @redis.zrangebyscore(@redis_key, ipaddr.to_i, "+inf", limit: [0, 1]).first
      next_range if IPAddr.new(next_range).include? ipaddr
    end
  end
end
