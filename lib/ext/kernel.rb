module Kernel
  def print_line(*args)
    Device::Display.print_line(*args)
  end
end