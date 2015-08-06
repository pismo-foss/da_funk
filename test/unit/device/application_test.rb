
class ApplicationTest < DaFunk::Test.case
  def setup
    @file_path = "./ttt"
    @string = "12345678901234567890"
    @file = File.open("./ttt", "w+")
    @file.write(@string)
    @file.close
    @crc = Device::Crypto.crc16_hex(@string)

  end

  def test_check_crc_true
    @application = Device::Application.new("TTT", @file_path, "ruby", @crc)
    assert_equal true, @application.valid_local_crc?
  end

  def test_check_crc_false
    @application = Device::Application.new("TTT", @file_path, "ruby", "1111")
    assert_equal false, @application.valid_local_crc?
  end

  def teardown
    File.delete(@file_path)
  end
end
