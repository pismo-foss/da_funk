# coding: utf-8
ib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version.rb'

Gem::Specification.new do |spec|
  spec.name          = "simplehttp"
  spec.version       = Device::API_VERSION
  spec.authors       = ["Thiago Scalone"]
  spec.email         = ["thiago@cloudwalk.io"]
  spec.summary       = "DaFunk API to embedded development"
  spec.description   = "DaFunk API to embedded development"
  spec.homepage      = "http://github.com/cloudwalkio/da_funk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.extensions = ["ext/simplehttp/extconf.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
