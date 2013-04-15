# -*- encoding: utf-8 -*-
require File.expand_path('../lib/puppet-newrelic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["George Bashi"]
  gem.email         = ["george@bashi.co.uk"]
  gem.description   = %q{This gem (horribly) monkey-patches your puppetmaster to add instrumentation with New Relic.}
  gem.summary       = %q{Puppet New Relic Instrumentation}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "puppet-newrelic"
  gem.require_paths = ["lib"]
  gem.version       = Puppet::NewRelic::VERSION

  gem.add_dependency("newrelic_rpm", ["~> 3.0"])
  gem.add_dependency("puppet", ["~> 2.7"])
end
