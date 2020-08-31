# Gem for Pcloud cloud storage

This Gem provides a Ruby interface to [Pcloud.com](https://pcloud.com).

[![Build Status](https://github.com/7urkm3n/pcloud/workflows/build/badge.svg?branch=master)]() [![Gem Version](https://badge.fury.io/rb/pcloud.svg)](https://rubygems.org/gems/pcloud)

## Installation and Configuration

Add `pcloud` to your Gemfile, and then run `bundle install`

``` ruby
gem 'pcloud'
```

or install via gem

``` bash
gem install pcloud
```

###### Rails
to generate `Rails` initializer file

```bash
rails generate pcloud
```

or add it manually into following path

```bash
config/initializers/pcloud.rb
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

The library can also be configured globally on the `Pcloud` class.

``` ruby
Pcloud.username = 'email'
Pcloud.password = 'password'
```

### Logging

By default errors are logged in STDOUT level, also `Rails.logger` available.

``` ruby
Pcloud.logger = Rails.logger
```

## Working with methods

Currently, only available custom Get method. 

File upload and Download methods are coming soon.


#### Get methods

``` ruby
pcloud.get("getip")
pcloud.get("getdigest")

# with params
pcloud.get("listfolder", folderid: 0)
pcloud.get("createfolder", folderid: 0, name: "new folder name")
```

<!-- #### Post methods

``` ruby
# with params
pcloud.get("createfolder", folderid: 0, name: "new folder name")
``` -->

### Supported Ruby versions
2.0+
