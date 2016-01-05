module Kernel
  def getc(timeout = 0)
    gets.chomp[0]
  end
end

class CommandLinePlatform
  IO = ::IO

  def self.setup
    Device::System.klass               = DaFunk::Test.name
    Device::Setting.logical_number     = DaFunk::Test.logical_number
    CommandLinePlatform::System.serial = DaFunk::Test.serial
    CommandLinePlatform::System.brand  = DaFunk::Test.brand
    CommandLinePlatform::System.model  = DaFunk::Test.model
    CommandLinePlatform::Display.standard_output = STDOUT
    Screen.setup(21, 20)
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
    class << self
      attr_accessor :standard_output
    end

    def self.print_in_line(buf, row = nil, column = nil)
      buf = (" " * column) + buf if column != nil && column > 0
      _puts buf
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

    def self._puts(*args)
      standard_output.puts(*args)
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
    class << self
      attr_accessor :serial, :brand, :model
    end

    def self.restart
      puts "Restart terminal!"
    end

    def self.versions
      {
        "OS"     => Device.version,
        "SDK"    => Device.api_version,
        "EMV"    => "0.0.1",
        "Pinpad" => "0.0.1"
      }
    end
  end

  def self.version
    "0.0.1"
  end
end

Device.adapter ||= CommandLinePlatform
CommandLinePlatform.setup

