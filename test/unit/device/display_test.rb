
class DisplayTest < DaFunk::Test.case
  def test_display_print
    assert_equal nil, Device::Display.print("test")
    assert_equal nil, Device::Display.print("test", 0)
    assert_equal nil, Device::Display.print("test", 0, 0)
  end

  def test_display_print_line
    assert_equal nil, Device::Display.print_line("test")
    assert_equal nil, Device::Display.print_line("test", 0)
    assert_equal nil, Device::Display.print_line("test", 0, 0)
  end

  def test_clear
    assert_equal nil, Device::Display.clear
    assert_equal nil, Device::Display.clear(2)
  end

  def test_print_bitmap
    assert_raise File::FileError do
      Device::Display.print_bitmap("test")
    end
  end

  def test_kernel_print_line
    assert_equal nil, print_line("test")
    assert_equal nil, print_line("test", 0)
    assert_equal nil, print_line("test", 0, 0)
  end

  def test_kernel_print
    assert_equal nil, print("test")
    assert_equal nil, print("test", 0)
    assert_equal nil, print("test", 0, 0)
  end

  def test_kernel_puts
    assert_equal nil, puts("test")
    assert_equal nil, puts("test", 0)
    assert_equal nil, puts("test", 0, 0)
  end

  def test_kernel_puts_break_line
    $stdout.fresh
    assert_equal nil, puts("\n")
    assert_equal 0, $stdout.x
    assert_equal 2, $stdout.y
    assert_equal nil, puts("")
    assert_equal 0, $stdout.x
    assert_equal 3, $stdout.y
  end

  def test_kernel_print_small
    $stdout.fresh
    assert_equal nil, print("1234")
    assert_equal 4, $stdout.x
    assert_equal 0, $stdout.y
  end

  def test_kernel_puts_small
    $stdout.fresh
    assert_equal nil, puts("1234")
    assert_equal 0, $stdout.x
    assert_equal 1, $stdout.y
  end

  def test_kernel_puts_string_20_plus_1
    $stdout.fresh
    assert_equal nil, print("12345678901234567890")
    assert_equal 20, $stdout.x
    assert_equal 0, $stdout.y
    assert_equal nil, puts("1")
    assert_equal 0, $stdout.x
    assert_equal 2, $stdout.y
  end

  def test_kernel_puts_string_21
    $stdout.fresh
    assert_equal nil, puts("123456789012345678901")
    assert_equal 0, $stdout.x
    assert_equal 2, $stdout.y
  end

  def test_kernel_puts_string_43
    $stdout.fresh
    assert_equal nil, puts("1234567890123456789012345678901234567890123")
    assert_equal 0, $stdout.x
    assert_equal 3, $stdout.y
  end

  def test_kernel_print_string_43
    $stdout.fresh
    assert_equal nil, print("1234567890123456789012345678901234567890123")
    assert_equal 1, $stdout.x
    assert_equal 2, $stdout.y
  end

  def test_kernel_puts_string_22
    $stdout.fresh
    assert_equal nil, puts("1234567890123456789012")
    assert_equal 0, $stdout.x
    assert_equal 2, $stdout.y
  end

  def test_kernel_print_string_22
    $stdout.fresh
    assert_equal nil, print("1234567890123456789012")
    assert_equal 1, $stdout.x
    assert_equal 1, $stdout.y
  end
end

