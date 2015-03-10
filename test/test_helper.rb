
if Object.const_defined?(:MTest)
  ROOT_PATH = File.expand_path("./")
  APP_NAME = File.basename(File.dirname(ROOT_PATH))

  $LOAD_PATH.unshift "./#{APP_NAME}"

  require 'da_funk'

  DaFunk::Test.configure do |t|
    t.root_path = ROOT_PATH
  end
else
  require "./lib/da_funk.rb"
  require "test/unit"
  require "./test/fixtures/platform.rb"
end

