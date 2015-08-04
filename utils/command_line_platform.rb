module Kernel
  def getc(timeout = 0)
    gets.chomp[0]
  end
end

class CommandLinePlatform
  IO = ::IO

  def self.setup
    begin
      require 'cloudwalk_handshake'
      CloudwalkHandshake.configure!
    rescue LoadError
    rescue NameError
    end
  end

  class IO
    def self.get_string(min, max, option = nil)
      str = ""
      while
        str << STDIN.gets.chomp
        return str if str.size >= min
      end
    end
  end

  class Display
    def self.print_in_line(buf, row = nil, column = nil)
      buf = (" " * column) + buf if column != nil && column > 0
      puts buf
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

    def self.restart
      puts "Restart terminal!"
    end
  end

  def self.version
    "0.0.1"
  end
end

Device.adapter ||= CommandLinePlatform
Device::System.klass = "main"
CommandLinePlatform.setup

