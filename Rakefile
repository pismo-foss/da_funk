#!/usr/bin/env rake

require 'rake/testtask'
require 'bundler/setup'
require 'yard'

Bundler.require(:default)
DA_FUNK_ROOT = File.dirname(File.expand_path(__FILE__))

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList['test/**/*test.rb']
  t.verbose = true
end

task :default => :compile

task :check do
  if ENV["MRBC"].nil?
    if system("type cloudwalk > /dev/null 2>&1 ")
      ENV["MRBC"] = "env cloudwalk compile"
    elsif system("type mrbc > /dev/null 2>&1 ")
      ENV["MRBC"] = "env mrbc"
    else
      puts "$MRBC isn't set or mrbc/cloudwalk isn't on $PATH"
      exit 0
    end
  end
end

desc "Compile da_funk to mrb"
task :compile => :check do
  files = [
    "lib/da_funk.rb",
    "lib/da_funk/test.rb",
    "lib/device.rb",
    "lib/device/audio.rb",
    "lib/device/crypto.rb",
    "lib/device/display.rb",
    "lib/device/helper.rb",
    "lib/device/io.rb",
    "lib/device/network.rb",
    "lib/device/params_dat.rb",
    "lib/device/printer.rb",
    "lib/device/runtime.rb",
    "lib/device/setting.rb",
    "lib/device/support.rb",
    "lib/device/system.rb",
    "lib/device/transaction/download.rb",
    "lib/device/transaction/emv.rb",
    "lib/device/version.rb",
    "lib/device/walk.rb",
    "lib/file_db.rb",
    "lib/iso8583/bitmap.rb",
    "lib/iso8583/codec.rb",
    "lib/iso8583/exception.rb",
    "lib/iso8583/field.rb",
    "lib/iso8583/fields.rb",
    "lib/iso8583/message.rb",
    "lib/iso8583/util.rb",
    "lib/iso8583/version.rb",
    "lib/version.rb",
    "lib/device/transaction/iso.rb"
  ]
  files = files.inject([]) {|array,file| array << File.join(DA_FUNK_ROOT, file)}
  out   = File.join(DA_FUNK_ROOT, "out", "da_funk.mrb")

  FileUtils.mkdir_p(File.join(DA_FUNK_ROOT, "out"))
  if ENV["MRBC"]
    puts "Compilinggggg!!!"
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

desc "Generate YARD Documentation"
task :yard do
  Bundler.require(:default, :development)
  sh "yard"
end

