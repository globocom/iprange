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
      @redis.irem(@redis_key, range)
      @redis.del(metadata_key(range))
    end

    def add(range, metadata={})
      ipaddr_range = IPAddr.new(range).to_range
      @redis.iadd(@redis_key, ipaddr_range.first.to_i, ipaddr_range.last.to_i, range)
      hash = metadata_key(range)
      @redis.mapped_hmset(hash, metadata) unless metadata.empty?
    end

    def find(ip)
      ipaddr = IPAddr.new(ip)
      first_range = @redis.istab(@redis_key, ipaddr.to_i).first
      if first_range
        metadata = @redis.hgetall(metadata_key(first_range))
        {range: first_range}.merge(metadata)
      end
    end

    def metadata_key(range)
      "#{@redis_key}:#{range}"
    end
  end
end
