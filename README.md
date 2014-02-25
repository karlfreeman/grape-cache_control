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
# Cache-Control:public,max-age=900
cache_control :public, max_age: 900

# Cache-Control:public,no-store,max-age=900,s-maxage=86400
cache_control :public, :no_store, max_age: 900, s_maxage:86400

# Cache-Control:public,no-store,max-age=900,s-maxage=86400
cache_control :public, :no_store, max_age: (Time.now + 900), s_maxage: (Time.now + 86400)

# Cache-Control:private,must-revalidate,max=age=0
cache_control :private, :must_revalidate, max_age: 0

# Cache-Control: public,max-age=900
# Expires:Tue, 25 Feb 2014 12:00:00 GMT
expires 900, :public

# Cache-Control: private,no-cache,no-store,max-age=900
# Expires:Tue, 25 Feb 2014 12:00:00 GMT
expires (Time.now + 900), :private, :no_store
```

```ruby
class API < Grape::API

  desc 'A completely random endpoint'
  get '/very-random' do
    # ensure proxy cache's do not cache this
    cache_control :no_cache
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
    # cache for 15 minutes, however allow the proxy cache to cache for the whole day
    cache_control :public, max_age: 900, s_maxage 86400
    { reasonably_static: Time.at(Time.now.to_i - (Time.now.to_i % 86400)) }
  end

  desc 'A very secure endpoint'
  get '/your-bank-account-details' do
    # explicitly don't store or cache this response
    cache_control :private, :must_revalidate, max_age: 0
    { your_bank_account_details: '0000-0000-0000-0000' }
  end

  desc 'An endpoint which is sometimes private'
  get '/sometimes-private' do
    # cache for a minute but don't allow it to be stored
    cache_control :no_store, max_age: 60
    is_private = [true, false].sample
    # then merge ontop its privacy
    cache_control is_private ? :public : :private
    { sometimes_private: is_private }
  end
  
  desc 'An endpoint which expires based on some business logic'
  get '/randomly-expiring' do
    # specify upfront its public
    cache_control :public
    random_future_expiry = Random.rand(60 * 60) + 60
    is_expired = Time.now + random_future_expiry
    # then merge ontop is actual expiration
    cache_control max_age: is_expired
    { randomly_expiring: is_expired }
  end

end
```

Additional to the `cache_control` helper there is also an `expires` one too which augments cache_control as well as setting the `Expires` header

```ruby
class API < Grape::API

  desc 'An endpoint which rounds to the nearest 15 minutes'
  get '/fairly-static' do
    # cache for 15 minutes
    expires 900, :public
    { fairly_static: Time.at(Time.now.to_i - (Time.now.to_i % 900)) }
  end

  desc 'An endpoint which expires based on some business logic'
  get '/randomly-expiring' do
    is_expired = Time.now + Random.rand(60 * 60) + 60
    # expire in random future
    expires is_expired, :public
    { randomly_expiring: is_expired }
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

[grape]: http://intridea.github.io/grape
