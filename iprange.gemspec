# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iprange/version'

Gem::Specification.new do |spec|
  spec.name          = "iprange"
  spec.version       = Iprange::VERSION
  spec.authors       = ["Juarez Bochi"]
  spec.email         = ["jbochi@gmail.com"]
  spec.summary       = "IP ranges on Redis"
  spec.description   = "Save IP ranges on Redis for fast lookup using sorted sets"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redis"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
