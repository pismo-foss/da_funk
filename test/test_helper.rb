
if Object.const_defined?(:MTest)
  ROOT_PATH = File.expand_path("./")

  $LOAD_PATH.unshift "./out"
  require 'da_funk'

  DaFunk::Test.configure do |t|
    t.root_path = ROOT_PATH
  end
else
  require "./lib/da_funk.rb"
  require "test/unit"
  require "./test/fixtures/platform.rb"
end

