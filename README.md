# Grape::CacheControl

`Cache-Control` and `Expires` helpers for [Grape][grape]

## Installation

```ruby
gem 'grape-cache_control', '~> 0.0.1'
```

```ruby
require 'grape/cache_control'
```
## Features / Usage Examples


```ruby
class API < Grape::API

  desc 'A completely random endpoint'
  get '/very-random' do
    # no cache-control needed
    { very_random: Random.rand(100) }
  end

  desc 'An endpoint which rounds to the nearest 15 minutes'
  get '/fairly-static' do
    # cache for 15 minutes
    cache_control :public, max_age: 900
    { fairly_static: Time.at(Time.now.to_i - (Time.now.to_i % 900)) }
  end

  desc 'An endpoint which rounds to the nearest day'
  get '/reasonably-static' do
    # cache for 15 minutes, however alow the proxy cache to cache for the whole day
    cache_control :public, max_age: 900, s_maxage 86400
    { fairly_static: Time.at(Time.now.to_i - (Time.now.to_i % 86400)) }
  end

  desc 'A very secure endpoint'
  get '/very-secure' do
    # explicitly don't store or cache this response
    cache_control :private, :no_cache, :no_store
    { your_bank_account_details: '0000-0000-0000-0000' }
  end

  desc 'An endpoint which is sometimes private'
  get '/sometimes-private' do
    # cache for a minute but don't allow it to be stored
    cache_control :no_store, max_age: 60
    is_private = [true, false].sample
    # then merge ontop its privacy
    cache_control is_private ? :public : :private
    { private: is_private }
  end
  
  desc 'An endpoint which expires based on some business logic'
  get '/randomly-expiring' do
    # specify upfront its public
    cache_control :public
    random_future_expiry = Random.rand(60 * 60) + 60
    is_expired = Time.now + random_future_expiry
    # then merge ontop is actual expiration
    cache_control max_age: is_expired
    { expires_at: is_expired }
  end

end
```

## Build & Dependency Status

[![Gem Version](https://badge.fury.io/rb/grape-cache_control.png)][gem]
[![Build Status](https://travis-ci.org/karlfreeman/grape-cache_control.png)][travis]
[![Code Quality](https://codeclimate.com/github/karlfreeman/grape-cache_control.png)][codeclimate]
[![Gittip](http://img.shields.io/gittip/karlfreeman.png)][gittip]

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 2.1.0
* Ruby 2.0.0
* Ruby 1.9.3
* [JRuby][jruby]
* [Rubinius][rubinius]

# Credits

Inspiration:

- [Sinatra's Cache-Control / Expires](https://github.com/sinatra/sinatra/blob/faf2efc670bf4c6076c26d5234c577950c19b699/lib/sinatra/base.rb#L439-L492)

Cribbed:

- [Grape-Pagination](https://github.com/remind101/grape-pagination)

[gem]: https://rubygems.org/gems/grape-cache_control
[travis]: http://travis-ci.org/karlfreeman/grape-cache_control
[codeclimate]: https://codeclimate.com/github/karlfreeman/grape-cache_control
[gittip]: https://www.gittip.com/karlfreeman
[jruby]: http://www.jruby.org
[rubinius]: http://rubini.us

[grape]: http://intridea.github.io/grape
