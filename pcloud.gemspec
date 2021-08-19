# encoding: utf-8
require File.expand_path('../lib/pcloud/version', __FILE__)

Gem::Specification.new do |s|
  s.name                  = "pcloud"
  s.version               = Pcloud::VERSION
  s.platform              = Gem::Platform::RUBY
  s.date                  = Time.now.strftime('%Y-%m-%d')
  s.authors               = ["Rovshen Gurdov".freeze]
  s.email                 = ["rovshen@gurdov.com".freeze]
  s.homepage              = "https://github.com/7urkm3n/pcloud".freeze
  s.summary               = %q{Secure and simple to use cloud storage for your datas...}
  s.description           = %q{Pcloud is cloud storage upload/download/share from pcloud.com. Please, check available methods in Github Doc...}
  s.license              = "MIT"

  s.files                 = Dir["{lib}/**/*.rb", "LICENSE", "README.md", "Changelog.md"]
  s.require_paths         = ["lib".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2".freeze)

  s.add_dependency "rest-client", "~> 2.0"
  s.add_dependency "json", "~> 2.2.0"
  s.add_dependency "forwardable", "~> 1.2.0"

  # s.add_development_dependency "rspec", "~> 3.0"
  # s.add_development_dependency "rake", "~> 10.4.2"
  # s.add_development_dependency "rack", "~> 1.6.4"

  s.metadata = {
    "bug_tracker_uri"   => "#{s.homepage.to_s}/issues",
    "changelog_uri"     => "#{s.homepage.to_s}/blob/master/Changelog.md",
    "documentation_uri" => s.homepage.to_s,
    "source_code_uri"   => s.homepage.to_s,
  }

  s.bindir = "exe"
  s.executables = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
end
