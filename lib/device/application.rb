class Device
  class Application
    attr_reader :label, :file_path, :type, :crc, :order, :name

    def initialize(label, file_path, type, crc)
      @name = label
      @order, @label = split_label(label)
      @file_path = file_path
      @type      = type
      @crc       = crc
    end

    def file
      @file ||= file_path.gsub("#{Device::Setting.company_name}_", "")
    end

    def file_no_ext
      @file_no_ext ||= file.split(".")[0]
    end

    def zip
      @zip ||= "#{file_no_ext}.zip"
    end

    def outdated?
      return false unless File.exists?(@file_path)
      file = File.open(@file_path)
      Device::Crypto.crc16_hex(file.read) == @crc
    ensure
      file.close if file
    end

    def execute(json = "")
      if posxml?
        Device::Runtime.execute(remote, json)
      else
        Device::Runtime.execute(name, json)
      end
    end

    def posxml?
      @type == "posxml" || remote.include?(".posxml")
    end

    def ruby?
      @type == "ruby" || (! remote.include? ".posxml")
    end

    private
    def split_label(text)
      if text == "X"
        number, text = 0, "X"
      else
        number, text = text.to_s.split(" - ")
      end

      [number.to_i, text.to_s]
    end
  end
end

