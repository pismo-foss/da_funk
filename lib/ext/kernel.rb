module Kernel
  def print_line(*args)
    Device::Display.print_line(*args)
  end

  def get_format(*args)
    Device::IO.get_format(*args)
  end
end