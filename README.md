# Puppet New Relic Instrumentation

This gem (horribly) monkey-patches your puppetmaster to add instrumentation with New Relic.
Currently this adds transaction traces around requests and puppet-language function calls.

## Installation

    $ gem install puppet-newrelic

## Usage

In your `config.ru`, add at the top:
 
	require 'newrelic_rpm'
    require 'puppet-newrelic'

Create a directory called `config` in the same directory as your `config.ru` (`/usr/share/puppet/rack/puppetmasterd/` for Ubuntu, probably others). In there, drop a [New Relic `config.yml`](https://newrelic.com/docs/ruby/ruby-agent-configuration). Restart your puppetmaster and it should all kick off!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
