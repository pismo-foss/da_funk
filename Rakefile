#!/usr/bin/env rake

require 'rake/testtask'
require 'bundler/setup'
require 'yard'

#Bundler.require(:default)
DA_FUNK_ROOT = File.dirname(File.expand_path(__FILE__))

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end

YARD::Rake::YardocTask.new do |t|
  t.options = ['--debug'] # optional arguments
end

task :default => :compile

task :check do
  if ENV["MRBC"].nil? && ! system("type mrbc > /dev/null 2>&1 ")
    puts "$MRBC isn't set or mrbc isn't on $PATH"
    exit 0
  end
end

desc "Compile da_funk to mrb"
task :compile => :check do
  files = FileList[File.join(DA_FUNK_ROOT, 'lib/**/*.rb')]
  out   = File.join(DA_FUNK_ROOT, "out", "da_funk.mrb")

  FileUtils.mkdir_p(File.join(DA_FUNK_ROOT, "out"))
  if ENV["MRBC"]
    sh "#{ENV["MRBC"]} -o #{out} #{files.join(" ")}"
  else
    sh "env mrbc -o #{out} #{files.join(" ")}"
  end
end

desc "Clobber/Clean PAX"
task :clean => :check do
  sh "mkdir -p out"
  sh "rm -f out/da_funk.mrb"
end
