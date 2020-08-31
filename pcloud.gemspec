# encoding: utf-8

require File.expand_path('../lib/pcloud/version', __FILE__)

Gem::Specification.new do |s|
  s.name                  = "pcloud"
  s.version               = Pcloud::VERSION
  s.platform              = Gem::Platform::RUBY
  s.date                  = Time.now.strftime('%Y-%m-%d')
  s.authors               = ["Rovshen Gurdov"]
  s.email                 = ["rovshen@gurdov.com"]
  s.homepage              = "https://rubygems.org/gems/pcloud"
  s.summary               = %q{Secure and simple to use cloud storage for your datas...}
  s.description           = %q{Pcloud is online storage upload/download/share from pcloud.com. Currently not supports all API URLs. Please, check available methods in Github Doc...}
  s.license               = 'MIT'

  s.files                 = Dir["{lib}/**/*.rb", "LICENSE", "README.md"]
  s.test_files            = Dir["spec/*.rb"]
  # s.executables           = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths         = ["lib"]
  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'rest-client', '~> 2.0'
  s.add_dependency 'json', '~> 2.2.0'
  s.add_dependency 'forwardable', '~> 1.2.0'

  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rake", "~> 10.4.2"
  s.add_development_dependency "rack", "~> 1.6.4"

end
