# IPRange

Store IP Ranges in Redis as sorted sets for fast retrieval

## Installation

Add this line to your application's Gemfile:

    gem 'iprange'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iprange

## Usage

    > redis_config = {host: "127.0.0.1"}
    > range = IPRange::Range.new(redis_config)
    > range.add("192.168.0.1/24", some: "data", more: "metadata")
    > range.find("192.168.0.20")
    => {:range=>"192.168.0.1/24", "some"=>"data", "more"=>"metadata"}

## Notice

The ranges MUST not overlap! If they do, you should consider using the `redis-intervals` branch, that relies on [a Redis fork that implements interval sets](https://github.com/hoxworth/redis/tree/2.6-intervals), as described in this [blog post](http://blog.togo.io/how-to/adding-interval-sets-to-redis/).

## Contributing

1. Fork it ( http://github.com/jbochi/iprange/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
