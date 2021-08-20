# Gem for Pcloud cloud storage

This Gem provides a Ruby interface to [Pcloud.com](https://docs.pcloud.com).

[![Build Status](https://github.com/7urkm3n/pcloud/workflows/release/badge.svg?branch=main)](https://github.com/7urkm3n/pcloud/actions?query=workflow%3Arelease) [![Gem Downloads](https://badgen.net/rubygems/dt/pcloud)](https://rubygems.org/gems/pcloud) [![Gem Version](https://badge.fury.io/rb/pcloud.svg)](https://badge.fury.io/rb/pcloud)

<!-- [![Gem Version](https://badgen.net/rubygems/v/pcloud)](https://rubygems.org/gems/pcloud) -->

## Installation and Configuration

Add `pcloud` to your Gemfile, and then run `bundle install`

```ruby
gem 'pcloud'
```

or install via gem

```bash
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

```ruby
require 'pcloud'

pcloud = Pcloud::Client.new(
  username: 'email',
  password: 'password',
)
```

### Global configuration

The library can also be configured globally on the `Pcloud` class.

```ruby
Pcloud.username = 'email'
Pcloud.password = 'password'
```

<!-- ### Logging

By default errors are logged in STDOUT level, also `Rails.logger` available.

``` ruby
Pcloud.logger = Rails.logger
``` -->

## Working with methods

Currently, only available custom Get method.

File Upload and Download methods are coming soon.

#### Get methods

```ruby
Pcloud.get("getip")
Pcloud.get("getdigest")

# with params
Pcloud.get("listfolder", folderid: 0)
```

<!-- Pcloud.get("createfolder", folderid: 0, name: "new folder name", ...) -->

#### Post methods

```ruby
# if any of pcloud endpoints requires payload on POST request, please create an issue.

# with params
Pcloud.post("createfolder", folderid: 0, name: "new folder name")
```

#### [Files](https://docs.pcloud.com/methods/file/)

##### [Download File](https://docs.pcloud.com/methods/file/downloadfile.html)

```ruby
#obtain filelink from: https://docs.pcloud.com/methods/streaming/getfilelink.html

Pcloud.file.download(
  url: filelink,                           #required
  destination: "#{Dir.pwd}/Downloads",     #required
  filename: "hehe.txt"                     #optional
)
```

##### [Upload File](https://docs.pcloud.com/methods/file/uploadfile.html)

```ruby
# still in BETA! -
# only supports single file upload

file = File.open("/Users/7urkm3n/Downloads/anything.file")
params = {
  folderid: 0,                #required
  filename: "anything.txt"    #required
}
payload = {file: file}
Pcloud.file.upload(params, payload)
```

### Supported Ruby versions

2.2+
