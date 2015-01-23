class Device
  module Helper
    def form(txt, min=0, max=8, default="", is_number=true)
      Device::Display.clear
      puts txt

      if is_number
        string = get_string(min, max, IO_INPUT_NUMBERS)
      else
        string = get_string(min, max)
      end
      return default if string.empty?
      string
    end

    def attach
      Device::Display.clear
      puts "Connecting..."
      if Device::Network.connected? < 0
        if (ret = Device::Network.attach) == 0
          puts "Connected #{ret}"
        else
          puts "Attach fail #{ret}"
          sleep 4
          return false
        end
      else
        puts "Already connected"
      end
      true
    end

    # TODO Add i18n or something
    def check_download_error(ret)
      value = true
      case ret
      when Device::Transaction::Download::SERIAL_NUMBER_NOT_FOUND
        puts "Serial number not found."
        value =  false
      when Device::Transaction::Download::FILE_NOT_FOUND
        puts "File not found."
        value = false
      when Device::Transaction::Download::FILE_NOT_CHANGE
        puts "File is the same."
      when Device::Transaction::Download::SUCCESS
        puts "Success."
      when Device::Transaction::Download::COMMUNICATION_ERROR
        puts "Communication failure."
        value = false
      when Device::Transaction::Download::MAPREDUCE_RESPONSE_ERROR
        puts "Encoding error."
        value = false
      when Device::Transaction::Download::IO_ERROR
        puts "IO Error."
        value = false
      else
        puts "Communication fail."
        value = false
      end

      value
    end

    # {"option X" => {:detail => 10}, "option Y" => {:detail => 11}}
    def menu(title, options)
      Device::Display.clear
      puts(title)
      values = Hash.new
      options.each_with_index do |value,i|
        values[i.to_i] = value[1]
        Device::Display.print(value[0], i+2)
      end

      [values[getc.to_i - 1]].flatten.first
    end
    def ljust(string, size, new_string)
      string = string.to_s
      if size > string.size
        string + (new_string * (size - string.size))
      else
        string
      end
    end

    def rjust(string, size, new_string)
      string = string.to_s
      if size > string.size
        (new_string * (size - string.size)) + string
      else
        string
      end
    end
  end
end
