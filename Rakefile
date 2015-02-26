#!/usr/bin/env rake

require 'rake/testtask'
require 'bundler/setup'

Bundler.require(:default)
DA_FUNK_ROOT = File.dirname(File.expand_path(__FILE__))

FileUtils.cd DA_FUNK_ROOT

FILES = FileList[
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
  "lib/device/transaction/iso.rb",
  "lib/serfx.rb",
  "lib/serfx/commands.rb",
  "lib/serfx/connection.rb",
  "lib/serfx/response.rb",
  "lib/serfx/exceptions.rb",
  "lib/device/notification_event.rb",
  "lib/device/notification_callback.rb",
  "lib/device/notification.rb",
  "lib/device/application.rb",
  "lib/ext/kernel.rb"
]

DaFunk::RakeTask.new do |t|
  t.mruby = "mruby -b"
  t.main_out  = "./out/da_funk.mrb"
  t.libs = FILES
end

desc "Generate YARD Documentation"
task :yard do
  Bundler.require(:default, :development)
  sh "yard"
end

task "test:all"         => :build
task "test:unit"        => :build
task "test:integration" => :build
