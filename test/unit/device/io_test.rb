
class IOTest < DaFunk::Test.case
  def test_io_change_next
    text = "TES8"
    assert_equal "TESt", Device::IO.change_next(text)
    assert_equal "TESu", Device::IO.change_next(text)
    assert_equal "TESv", Device::IO.change_next(text)
    assert_equal "TEST", Device::IO.change_next(text)
    assert_equal "TESU", Device::IO.change_next(text)
    assert_equal "TESV", Device::IO.change_next(text)
  end

  def test_io_insert_key_number
    assert Device::IO.insert_key?("1", {:mode => Device::IO::IO_INPUT_NUMBERS})
  end

  def test_io_insert_key_decimal
    assert Device::IO.insert_key?("1", {:mode => Device::IO::IO_INPUT_DECIMAL})
  end

  def test_io_insert_key_money
    assert Device::IO.insert_key?("1", {:mode => Device::IO::IO_INPUT_MONEY})
  end

  def test_io_insert_key_number_false
    assert_equal false, Device::IO.insert_key?("a", {:mode => Device::IO::IO_INPUT_NUMBERS})
  end

  def test_io_insert_key_decimal_false
    assert_equal false, Device::IO.insert_key?("a", {:mode => Device::IO::IO_INPUT_DECIMAL})
  end

  def test_io_insert_key_money_false
    assert_equal false, Device::IO.insert_key?("a", {:mode => Device::IO::IO_INPUT_MONEY})
  end

  def test_io_format_string_to_money
    options = {:mode => Device::IO::IO_INPUT_MONEY}
    assert_equal "10,000.00", Device::IO.format("1000000", options)
  end

  def test_io_format_string_to_decimal
    options = {:mode => Device::IO::IO_INPUT_DECIMAL}
    assert_equal "10,000.00", Device::IO.format("1000000", options)
  end

  def test_io_format_string_to_secret
    options = {:mode => Device::IO::IO_INPUT_SECRET}
    assert_equal "*******", Device::IO.format("1000000", options)
  end
end

