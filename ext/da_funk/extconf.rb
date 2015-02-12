p require 'rake'
p require 'mkmf'

ENV["BUNDLE_GEMFILE"] = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "Gemfile")
p rakefile = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "Rakefile")

if sh "bundle exec rake -f #{rakefile}"
  $makefile_created = true
end
