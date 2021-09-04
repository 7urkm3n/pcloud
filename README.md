# Gem for Pcloud cloud storage

This Gem provides a Ruby interface to [Pcloud.com](https://docs.pcloud.com).

[![Build Status](https://github.com/7urkm3n/pcloud/workflows/release/badge.svg?branch=main)](https://github.com/7urkm3n/pcloud/actions?query=workflow%3Arelease) [![Gem Downloads](https://badgen.net/rubygems/dt/pcloud)](https://rubygems.org/gems/pcloud) [![Gem Version](https://badge.fury.io/rb/pcloud.svg)](https://badge.fury.io/rb/pcloud)

<!-- [![Gem Version](https://badgen.net/rubygems/v/pcloud)](https://rubygems.org/gems/pcloud) -->

##### Want to contribute? [Doc Link](https://github.com/7urkm3n/pcloud/CONTRIBUTE.md)

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
).authenticate #authenticate returns auth object

pcloud.get("listfolder", folderid: 0)
```

### Global configuration

The library can also be configured globally on the `Pcloud` class.

```ruby
Pcloud.username = 'email'
Pcloud.password = 'password'
Pcloud.authenticate #authenticate returns auth object

Pcloud.get("listfolder", folderid: 0)
```

### Logging

By default errors are logged in STDOUT level, also `Rails.logger` available.

```ruby
Pcloud.logger = Rails.logger
```

### Working with methods

Available methods:

- <b> Get </b>
- <b> Post </b>
- <b> File handling </b>

###### addition!

> Some apis need to be `raw` format, just add `raw` in params. `params: {fileid: ..987, raw: true}`
> For example `gettextfile` > https://docs.pcloud.com/methods/streaming/gettextfile.html

#### Get method

```ruby
Pcloud.get("getip")
Pcloud.get("getdigest")

# with params
params = {folderid: 0}
Pcloud.get("listfolder", params)
```

#### Post method

```ruby
payload = {}
params = {folderid: 0, name: "new folder name"}
Pcloud.post("createfolder", payload, params)
```

### [File methods](https://docs.pcloud.com/methods/file/)

##### [Download File](https://docs.pcloud.com/methods/file/downloadfile.html)

```ruby
# optional params: filename, destination
# destination by default current_path
Pcloud.file.download({fileid: 987532135})

Pcloud.file.download(
  fileid: 987532135,                   #required
  destination: "#{Dir.pwd}/Downloads", #optional
  filename: "hehe.txt"                 #optional
)
```

##### [Download Folder](#)

```ruby
# optional params: filename, destination
# destination by default current_path
Pcloud.file.download_folder({folderid: 123456789})
```

##### [Upload File](https://docs.pcloud.com/methods/file/uploadfile.html)

```ruby
params = {
  folderid: 0,  #required
  nopartial: 1,
}
# multiple uploads
file1 = File.open("./Rakefile")
file2 = File.open("./README.md")
file3 = File.open("./Gemfile")
payload = { files: [file1,file2,file3] }

Pcloud.file.upload(params, payload)
```

### Supported Ruby versions

2.2+
