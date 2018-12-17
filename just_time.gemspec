# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "just_time"

Gem::Specification.new do |spec|
  spec.name     = "just_time"
  spec.version  = JustTime::VERSION
  spec.authors  = ["Andy Jones"]
  spec.email    = ["andy@twosticksconsulting.co.uk"]

  spec.summary  = %q|a little class to handle time-without-date|
  spec.homepage = "https://bitbucket.org/andy-twosticks/just_time"
  spec.license  = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.8"
end
