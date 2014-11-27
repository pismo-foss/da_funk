require 'yard'
require 'rake/testtask'

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
  funk_files = [
    "lib/device/support.rb",
    "lib/device/crypto.rb",
    "lib/device/display.rb",
    "lib/device/audio.rb",
    "lib/device/io.rb",
    "lib/device/network.rb",
    "lib/device/printer.rb",
    "lib/device/setting.rb",
    "lib/device/system.rb",
    "lib/device/version.rb",
    "lib/device/walk.rb",
    "lib/device.rb",
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
    "lib/device/transaction/download.rb",
    "lib/device/transaction/emv.rb",
    "lib/device/transaction/iso.rb"
  ]

  out   = File.join(DA_FUNK_ROOT, "out", "da_funk.mrb")
  files = funk_files.inject([]) {|files,file| files << File.join(DA_FUNK_ROOT, file)}

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
