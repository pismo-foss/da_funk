module Kernel
  def get_format(*args)
    Device::IO.get_format(*args)
  end

  def print_line(buf, row = 0, column = 0)
    Device::Display.print_line(buf, row, column)
  end
end
