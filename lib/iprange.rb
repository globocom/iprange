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
      @redis.pipelined do
        @redis.irem(@redis_key, range)
        @redis.del(metadata_key(range))
      end
    end

    def add(range, metadata={})
      ipaddr_range = IPAddr.new(range).to_range
      range = "#{metadata[:key]}:#{range}" if metadata[:key]
      hash = metadata_key(range)

      @redis.pipelined do
        @redis.iadd(@redis_key, ipaddr_range.first.to_i, ipaddr_range.last.to_i, range)
        @redis.mapped_hmset(hash, metadata) unless metadata.empty?
      end
    end

    def find(ip)
      find_all(ip).first
    end

    def find_all(ip)
      ipaddr = IPAddr.new(ip)
      ranges = @redis.istab(@redis_key, ipaddr.to_i)
      ranges.map do |range|
        metadata = @redis.hgetall(metadata_key(range))
        {range: range}.merge(metadata)
      end
    end

    def metadata_key(range)
      "#{@redis_key}:#{range}"
    end
  end
end
