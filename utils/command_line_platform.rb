
module GetC
  def getc
    puts "asasdfasf"
    str = gets
    str[0]
  end
end

include GetC

class CommandLinePlatform
  IO = ::IO

  class IO
    def self.get_string(min, max)
      str = ""
      while
        str << gets
        return str if str.size >= min
      end
    end

    def self.display(buf, row = 0, column = 0)
      self.print_line(buf, row, column)
    end

    def self.display_clean
      # No way to clear from the CLI yet
      # we could use ncurses, but that's painful
    end
  end

  class Display
    def self.print_line(buf, row = nil, column = nil)
      buf = (" " * column) + buf if column != nil && column > 0
      puts buf
    end

    def self.print(*args)
      self.print_line(*args)
    end

    def self.clear
      # No way to clear from the CLI yet
      # we could use ncurses, but that's painful
    end

    def self.clear_line(line = nil)
      # No way to clear from the CLI yet
      # we could use ncurses, but that's painful
    end

    def self.display_bitmap(path, row, column)
    end
  end

  class Network
    def self.started?
      true
    end

    def self.connected?
      1
    end
  end

  class System
    def self.serial
      "50111541"
    end
  end

  def self.version
    "0.0.1"
  end

  def self.execute(file)
    begin
      dir = get_dir(file)
      $LOAD_PATH = [dir]

      if File.exist?("#{dir}/da_funk.mrb")
        require "da_funk.mrb"
      else
        require "./robot_rock/da_funk.mrb"
      end

      require "./robot_rock/pax.mrb"

      require "main.mrb"

      # Test.run
      Main.call
    rescue => @exception
      PAX.display_clear
      puts "#{@exception.class}: #{@exception.message}"
      puts "#{@exception.backtrace[0..2].join("\n")}"
      getc
      return nil
    end
  end
end

Device.adapter ||= CommandLinePlatform

