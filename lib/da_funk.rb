unless Object.const_defined?(:MTest)
  file_path = File.dirname(File.realpath(__FILE__))
  require file_path + "/da_funk/helper.rb"
  require file_path + "/da_funk/iso8583.rb"
  require file_path + "/da_funk/rake_task.rb"
  require file_path + "/da_funk/test.rb"
  require file_path + "/device/support.rb"
  require file_path + "/device/helper.rb"
  require file_path + "/device/crypto.rb"
  require file_path + "/device/display.rb"
  require file_path + "/device/io.rb"
  require file_path + "/device/network.rb"
  require file_path + "/device/printer.rb"
  require file_path + "/device/setting.rb"
  require file_path + "/device/system.rb"
  require file_path + "/device/version.rb"
  require file_path + "/device/params_dat.rb"
  require file_path + "/device.rb"
  require file_path + "/file_db.rb"
  require file_path + "/iso8583/bitmap.rb"
  require file_path + "/iso8583/codec.rb"
  require file_path + "/iso8583/exception.rb"
  require file_path + "/iso8583/field.rb"
  require file_path + "/iso8583/fields.rb"
  require file_path + "/iso8583/message.rb"
  require file_path + "/iso8583/util.rb"
  require file_path + "/iso8583/version.rb"
  require file_path + "/device/transaction/download.rb"
  require file_path + "/device/transaction/emv.rb"
  require file_path + "/device/transaction/iso.rb"
end

module DaFunk
  def self.setup_command_line
    # TODO Setup the environment to command line
  end
end

