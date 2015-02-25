class Device
  class Application
    attr_reader :label, :file_path, :type, :crc

    def initialize(label, file_path, type, crc)
      @label     = label
      @file_path = file_path
      @type      = type
      @crc       = crc
    end

    def file
      @file_name ||= file_path.gsub("#{Device::Setting.company_name}_", "")
    end

    def file_no_ext
      @file ||= file_name.split(".")[0]
    end

    def zip
      @zip ||= "#{file_no_ext}.zip"
    end

    def execute(json = "")
      Device::Runtime.execute(file_no_ext, json)
    end
  end
end