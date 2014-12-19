# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

tasks = File.expand_path('../tasks', __FILE__)
$LOAD_PATH.unshift(tasks) unless $LOAD_PATH.include?(tasks)

require 'version.rb'

Gem::Specification.new do |spec|
  spec.name          = "da_funk"
  spec.version       = Device::API_VERSION
  spec.authors       = ["Thiago Scalone"]
  spec.email         = ["thiago@cloudwalk.io"]
  spec.summary       = "DaFunk API to embedded development"
  spec.description   = "DaFunk API to embedded development"
  spec.homepage      = "http://github.com/cloudwalkio/da_funk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.extensions = ["ext/da_funk/extconf.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", "~> 10.4.2"
  spec.add_dependency "yard", ">= 0.8"
  spec.add_dependency "rdoc", ">= 4.1.1"
  spec.add_dependency "bundler", ">= 1.7"
end
