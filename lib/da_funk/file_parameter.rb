module DaFunk
  class FileParameter
    FILEPATH = "./shared"
    attr_reader :name, :file, :crc, :crc_local, :original, :remote

    def self.delete(collection)
      collection.each do |file_|
        file_.delete
      end
    end

    def initialize(name, crc)
      @crc      = crc
      @original = name
      @remote   = @original.sub("#{Device::Setting.company_name}_", "")
      @name     = @original.sub("#{Device::Setting.company_name}_", "").split(".")[0]
      @file     = "#{FILEPATH}/#{@remote}"
      @crc_local = @crc if File.exists?(@file)
    end

    def zip?
      @original.to_s[-4..-1] == ".zip"
    end

    def exists?
      File.exists? @file
    end

    def unzip
      if zip? && exists?
        Zip.uncompress(file, FILEPATH, false, false)
      end
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

    def delete
      File.delete(self.file) if exists?
    end

    def outdated?
      return true unless exists?
      unless @crc_local
        handle = File.open(file)
        @crc_local = Device::Crypto.crc16_hex(handle.read)
      end
      @crc_local != @crc
    ensure
      handle.close if handle
    end

    private
    def remove_company(name)
      name.split("_")[1..-1].join("_")
    end
  end
end

