# Scenario
# 1. Load from scratch
# - No file downloaded
# - with file downloaded
# 2. Second load
# - No crc update
# - With crc update

class Device
  class Application
    attr_reader :label, :file, :type, :crc, :order, :name, :remote, :original,
      :crc_local

    def self.delete(collection)
      collection.each do |app|
        app.delete
      end
    end

    def initialize(label, remote, type, crc)
      @type     = type
      @crc      = crc
      @original = remote
      @order, @label = split_label(label)
      @remote    = remote.sub("#{Device::Setting.company_name}_", "")
      @name      = remote.sub("#{Device::Setting.company_name}_", "").split(".")[0]
      @file      = check_path(@remote)
      @crc_local = @crc if File.exists?(@file)
    end

    def download(force = false)
      if force || outdated?
        ret = Device::Transaction::Download.request_file(remote, file, crc_local)
      else
        ret = Device::Transaction::Download::FILE_NOT_CHANGE
      end
      @crc_local = @crc if ret == Device::Transaction::Download::SUCCESS
      ret
    end

    def dir
      @name
    end

    def exists?
      File.exists? file
    end

    def delete
      File.delete(self.file) if exists?
      if self.ruby? && Dir.exist?(self.dir) && self.dir != "main"
        Dir.delete(self.dir)
      end
    end

    def outdated?
      return true unless File.exists?(file)
      unless @crc_local
        handle = File.open(file)
        @crc_local = Device::Crypto.crc16_hex(handle.read)
      end
      @crc_local != @crc
    ensure
      handle.close if handle
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

    def check_path(path)
      if posxml?
        "./shared/#{path}"
      else
        "#{path.gsub("#{Device::Setting.company_name}_", "")}.zip"
      end
    end

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

