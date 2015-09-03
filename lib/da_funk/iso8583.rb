unless Object.const_defined?(:MTest)
file_path = File.join(File.dirname(File.realpath(__FILE__)), "..")
  require file_path + "/da_funk/helper.rb"
  require file_path + "/iso8583/bitmap.rb"
  require file_path + "/iso8583/codec.rb"
  require file_path + "/iso8583/exception.rb"
  require file_path + "/iso8583/field.rb"
  require file_path + "/iso8583/fields.rb"
  require file_path + "/iso8583/message.rb"
  require file_path + "/iso8583/util.rb"
  require file_path + "/iso8583/version.rb"
end
