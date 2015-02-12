p require 'rake'
p require 'mkmf'

#p sh("bundle check")

#ENV["BUNDLE_GEMFILE"] = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "Gemfile")
p rakefile = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "Rakefile")

if sh "rake -f #{rakefile}"
  $makefile_created = true
end
