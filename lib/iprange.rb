require "iprange/version"
require "redis"
require "ipaddr"

module IPRange
  class Range
    def initialize(redis_config={}, redis_key="ip_table")
      @redis = Redis.new redis_config
      @redis_key = redis_key
    end

    def remove(range)
      @redis.zrem(@redis_key, range_key(range))
      @redis.del(metadata_key(range))
    end

    def add(range, metadata={})
      key = range_key(range)
      @redis.zadd(@redis_key, key, range)
      hash = metadata_key(range)
      @redis.mapped_hmset(hash, metadata) unless metadata.empty?
    end

    def find(ip)
      ipaddr = IPAddr.new(ip)
      next_range = @redis.zrangebyscore(@redis_key, ipaddr.to_i, "+inf", limit: [0, 1]).first
      if IPAddr.new(next_range).include? ipaddr
        metadata = @redis.hgetall(metadata_key(next_range))
        {range: next_range}.merge(metadata)
      end
    end

    private
    def range_key(range)
      IPAddr.new(range).to_range.last.to_i
    end

    def metadata_key(range)
      "#{@redis_key}:#{range}"
    end
  end
end
