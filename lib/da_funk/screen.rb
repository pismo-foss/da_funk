
class Screen
  SCREEN_X_SIZE = 21
  SCREEN_Y_SIZE = 7

  attr_accessor :x, :y, :max_x, :max_y

  def self.setup(max_x = SCREEN_X_SIZE, max_y = SCREEN_Y_SIZE)
    $stdout.close
    Object.const_set(:STDOUT, self.new(max_x, max_y))
    $stdout = Object::STDOUT
  end

  def initialize(max_x = SCREEN_X_SIZE, max_y = SCREEN_Y_SIZE)
    @max_x = max_x
    @max_y = max_y
    self.fresh
  end

  def fresh(value_y = 0, value_x = 0)
    @x = value_x || 0
    @y = value_y || 0
  end

  def jump_line(value = 1)
    @y += value
    @x = 0
    @y = 0 if (@y > (@max_y-1))
  end

  def print(*args)
    if n_strings?(args)
      loop_n_strings(*args)
    else
      loop_split_strings(*args)
    end
    nil
  end

  def printf(*args)
    print(sprintf(*args))
  end

  def puts(*args)
    if n_strings?(args)
      args = args.map {|str| "#{str}\n" }
    else
      args[0] = "#{args[0]}\n"
    end
    print(*args)
  end

  private
  def loop_split_strings(*args)
    str, value_x, value_x = *args
    value_y = @y unless value_y
    value_x = @x unless value_x

    str.lines.each_with_index do |string, index|
      jump_line if string[-1] == "\n"
      string = string.chomp
      if (@x + string.size) < @max_x
        Device::Display.print_line(string, @y, @x)
        @x += string.size
      else
        space = @max_x - @x
        Device::Display.print_line("#{string[0..(space - 1)]}", @y, @x)
        jump_line
        loop_split_strings("#{string[(space)..-1]}")
      end
    end
  end

  def loop_n_strings(*args)
    args.each { |str| self.print(str) }
  end

  # various arguments as string, example:
  #   puts "12", "23", "34"
  #   # or
  #   puts "12", 1, 2
  def n_strings?(args)
    if args[0].is_a?(String) && args[1].is_a?(String)
      true
    else
      false
    end
  end
end

