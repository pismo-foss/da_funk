
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
    assert_equal nil, Device::Display.print_bitmap("test")
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
end
