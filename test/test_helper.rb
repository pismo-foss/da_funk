ROOT_PATH = File.expand_path("./")
APP_NAME = File.basename(File.dirname(ROOT_PATH))

$LOAD_PATH.unshift "./#{APP_NAME}"

require 'da_funk'

DaFunk::Test.configure do |t|
  t.root_path      = ROOT_PATH
  t.serial         = "0000000001"
  t.logical_number = "001"
  t.name           = APP_NAME
end

