
class IOTest < DaFunk::Test.case
  def test_io_change_next_alphanumeric_mask
    text = "TES8"
    assert_equal "TESt", Device::IO.change_next(text)
    assert_equal "TESu", Device::IO.change_next(text)
    assert_equal "TESv", Device::IO.change_next(text)
    assert_equal "TEST", Device::IO.change_next(text)
    assert_equal "TESU", Device::IO.change_next(text)
    assert_equal "TESV", Device::IO.change_next(text)
    assert_equal "TES8", Device::IO.change_next(text)
  end

  def test_io_change_next_number_mask
    text = "TES8"
    assert_equal "TES8", Device::IO.change_next(text, :number)
    assert_equal "TES8", Device::IO.change_next(text, :number)
  end

  def test_io_change_next_letters_mask
    text = "TESt"
    assert_equal "TESu", Device::IO.change_next(text, :letters)
    assert_equal "TESv", Device::IO.change_next(text, :letters)
    assert_equal "TEST", Device::IO.change_next(text, :letters)
    assert_equal "TESU", Device::IO.change_next(text, :letters)
    assert_equal "TESV", Device::IO.change_next(text, :letters)
    assert_equal "TESt", Device::IO.change_next(text, :letters)
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

  def test_io_set_default_format_option
    options = {}
    options_default = {:mode => Device::IO::IO_INPUT_LETTERS, :line => 2, :column => 0}
    Device::IO.set_default_format_option(options)
    assert_equal options_default, options
  end

  def test_io_set_default_format_option_for_mask
    options = {:mode => Device::IO::IO_INPUT_MASK, :mask => "999-AAA-999/99.99"}
    options_default = {
      :mode => Device::IO::IO_INPUT_MASK,
      :mask_clean => "999AAA9999999",
      :mask => "999-AAA-999/99.99",
      :line => 2, :column => 0
    }
    Device::IO.set_default_format_option(options)
    assert_equal options_default, options
  end

  def test_io_check_mask_type_alpha
    options = { :mode => Device::IO::IO_INPUT_ALPHA }
    assert_equal Device::IO::MASK_ALPHA, Device::IO.check_mask_type("", options)
  end

  def test_io_check_mask_type_number
    options = { :mode => Device::IO::IO_INPUT_LETTERS }
    assert_equal Device::IO::MASK_LETTERS, Device::IO.check_mask_type("", options)
  end

  def test_io_check_mask_type_number_mask
    options = {
      :mode => Device::IO::IO_INPUT_MASK,
      :mask => "999-999/99.99",
      :mask_clean => "9999999999"
    }
    assert_equal Device::IO::MASK_NUMBERS, Device::IO.check_mask_type("", options)
  end

  def test_io_check_mask_type_letters_mask
    options = {
      :mode => Device::IO::IO_INPUT_MASK,
      :mask => "AAA-AAA/AA.AA",
      :mask_clean => "AAAAAAAAAA"
    }
    assert_equal Device::IO::MASK_LETTERS, Device::IO.check_mask_type("", options)
  end

  def test_io_check_mask_type_mix_letters_mask
    options = {
      :mode => Device::IO::IO_INPUT_MASK,
      :mask => "999-A99/99.99",
      :mask_clean => "999A999999"
    }
    assert_equal Device::IO::MASK_LETTERS, Device::IO.check_mask_type("111B", options)
  end

  def test_io_check_mask_type_mix_number_mask
    options = {
      :mode => Device::IO::IO_INPUT_MASK,
      :mask => "AAA-9AA/AA.AA",
      :mask_clean => "AAA9AAAAAA"
    }
    assert_equal Device::IO::MASK_NUMBERS, Device::IO.check_mask_type("SDF4", options)
  end
end

