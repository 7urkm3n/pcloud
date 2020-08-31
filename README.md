# Gem for Pcloud cloud storage

This Gem provides a Ruby interface to [Pcloud.com](https://pcloud.com).

[![Build Status](https://github.com/7urkm3n/pcloud/workflows/build/badge.svg?branch=master)]() [![Gem Version](https://badge.fury.io/rb/pcloud-storage.svg)](https://rubygems.org/gems/pcloud-storage)

## Installation and Configuration

Add `pcloud` to your Gemfile, and then run `bundle install`

``` ruby
gem 'pcloud'
```

or install via gem

``` bash
gem install pcloud
```



### Instantiating a client

``` ruby
require 'pcloud'

pcloud = Pcloud::Client.new(
  username: 'email',
  password: 'password',
)
```


### Global configuration

The library can also be configured globally on the `Pusher` class.

``` ruby
Pcloud.username = 'email'
Pcloud.password = 'password'
```


## Working with methods

Currently 

### Logging

By default errors are logged in STDOUT level, also `Rails.logger` available 

``` ruby
Pusher.logger = Rails.logger
```

#### Get methods

``` ruby
pcloud.get("getip")
pcloud.get("getdigest")

# with params
pcloud.get("listfolder", folderid: 0)
```

#### Get methods

``` ruby
pcloud.post("getip")

# with params
pcloud.get("createfolder", folderid: 0)
```

An optional fourth argument may be used to send additional parameters to the API, for example to [exclude a single connection from receiving the event](https://pusher.com/docs/channels/server_api/excluding-event-recipients).

``` ruby
pusher.trigger('channel', 'event', {foo: 'bar'}, {socket_id: '123.456'})
```

#### Batches

It's also possible to send multiple events with a single API call (max 10
events per call on multi-tenant clusters):

``` ruby
pusher.trigger_batch([
  {channel: 'channel_1', name: 'event_name', data: { foo: 'bar' }},
  {channel: 'channel_1', name: 'event_name', data: { hello: 'world' }}
])
```

#### Deprecated publisher API

Most examples and documentation will refer to the following syntax for triggering an event:

``` ruby
Pusher['a_channel'].trigger('an_event', :some => 'data')
```

This will continue to work, but has been replaced by `pusher.trigger` which supports one or multiple channels.

### Getting information about the channels in your Pusher Channels app

This gem provides methods for accessing information from the [Channels HTTP API](https://pusher.com/docs/channels/library_auth_reference/rest-api). The documentation also shows an example of the responses from each of the API endpoints.

The following methods are provided by the gem.

- `pusher.channel_info('channel_name', {info:"user_count,subscription_count"})` returns a hash describing the state of the channel([docs](https://pusher.com/docs/channels/library_auth_reference/rest-api#get-channels-fetch-info-for-multiple-channels-)).

- `pusher.channel_users('presence-channel_name')` returns a list of all the users subscribed to the channel (only for Presence Channels) ([docs](https://pusher.com/docs/channels/library_auth_reference/rest-api#get-channels-fetch-info-for-multiple-channels-)).

- `pusher.channels({filter_by_prefix: 'presence-', info: 'user_count'})` returns a hash of occupied channels (optionally filtered by prefix, f.i. `presence-`), and optionally attributes for these channels ([docs](https://pusher.com/docs/channels/library_auth_reference/rest-api#get-channels-fetch-info-for-multiple-channels-)).

### Asynchronous requests

There are two main reasons for using the `_async` methods:

* In a web application where the response from the Channels HTTP API is not used, but you'd like to avoid a blocking call in the request-response cycle
* Your application is running in an event loop and you need to avoid blocking the reactor

Asynchronous calls are supported either by using an event loop (eventmachine, preferred), or via a thread.

The following methods are available (in each case the calling interface matches the non-async version):

* `pusher.get_async`
* `pusher.post_async`
* `pusher.trigger_async`

It is of course also possible to make calls to the Channels HTTP API via a job queue. This approach is recommended if you're sending a large number of events.

#### With EventMachine

* Add the `em-http-request` gem to your Gemfile (it's not a gem dependency).
* Run the EventMachine reactor (either using `EM.run` or by running inside an evented server such as Thin).

The `_async` methods return an `EM::Deferrable` which you can bind callbacks to:

``` ruby
pusher.get_async("/channels").callback { |response|
  # use reponse[:channels]
}.errback { |error|
  # error is an instance of Pusher::Error
}
```

A HTTP error or an error response from Channels will cause the errback to be called with an appropriate error object.

#### Without EventMachine

If the EventMachine reactor is not running, async requests will be made using threads (managed by the httpclient gem).

An `HTTPClient::Connection` object is returned immediately which can be [interrogated](http://rubydoc.info/gems/httpclient/HTTPClient/Connection) to discover the status of the request. The usual response checking and processing is not done when the request completes, and frankly this method is most useful when you're not interested in waiting for the response.


## Authenticating subscription requests

It's possible to use the gem to authenticate subscription requests to private or presence channels. The `authenticate` method is available on a channel object for this purpose and returns a JSON object that can be returned to the client that made the request. More information on this authentication scheme can be found in the docs on <https://pusher.com/docs/channels/server_api/authenticating-users>

### Private channels

``` ruby
pusher.authenticate('private-my_channel', params[:socket_id])
```

### Presence channels

These work in a very similar way, but require a unique identifier for the user being authenticated, and optionally some attributes that are provided to clients via presence events:

``` ruby
pusher.authenticate('presence-my_channel', params[:socket_id],
  user_id: 'user_id',
  user_info: {} # optional
)
```

## Receiving WebHooks

A WebHook object may be created to validate received WebHooks against your app credentials, and to extract events. It should be created with the `Rack::Request` object (available as `request` in Rails controllers or Sinatra handlers for example).

``` ruby
webhook = pusher.webhook(request)
if webhook.valid?
  webhook.events.each do |event|
    case event["name"]
    when 'channel_occupied'
      puts "Channel occupied: #{event["channel"]}"
    when 'channel_vacated'
      puts "Channel vacated: #{event["channel"]}"
    end
  end
  render text: 'ok'
else
  render text: 'invalid', status: 401
end
```

## Supported Ruby versions
2.4+
