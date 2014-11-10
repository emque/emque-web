# Emque::Web

A simple administration / monitoring app for emque-consuming applications.

## Installation

Add this lines to your application's Gemfile:

```ruby
gem 'emque-web'

# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', '~> 1.3', :require => nil
```

And then execute:

```
$ bundle
```

## Usage

Add the following to your config/routes.rb:

```ruby
require "emque/web"
mount Emque::Web => "/emque"
```

Then configure it to point at the status address for your emque-consuming app(s)

```ruby
# config/initializers/emque_web.rb
require "emque/web"

Emque::Web.configure do
  config.sources = ["localhost:9292", "localhost:10000", ...]
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/emque-web/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
