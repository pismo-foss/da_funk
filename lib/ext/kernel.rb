module Kernel
  def print_line(*args)
    Device::Display.print_line(*args)
  end

  def get_string(*args)
    Device::IO.get_string(*args)
  end
end