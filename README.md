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

The ranges MUST not overlap!

## Contributing

1. Fork it ( http://github.com/jbochi/iprange/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
