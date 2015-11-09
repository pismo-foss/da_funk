module DaFunk
  module Helper
    def self.included(base)
      base.extend self
    end

    def form(label, options = {})
      Device::Display.clear
      options = form_default(options)
      default = options.delete(:default)
      puts "#{label} (#{default}):"
      string = get_format(options.delete(:min), options.delete(:max), options)
      return default if string.nil? || string.empty?
      string
    end

    def attach
      Device::Display.clear
      puts "Connecting..."
      if Device::Network.connected? < 0
        if (ret = Device::Network.attach) == 0
          puts "Successfully Connected"
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

    # @example
    #   options = {
    #     # default value to return if enter, you can work with complex data.
    #     :default => 10,
    #     # Add number to label or not
    #     :number => true,
    #     # Input Timeout in miliseconds
    #     :timeout => 30_000
    #   }
    #
    #   selection = {
    #     "option X" => 10,
    #     "option Y" => 11
    #   }
    #
    #   menu("Option menu", selection, options)
    #
    def menu(title, selection, options = {})
      options[:number] = true if options[:number].nil?

      Device::Display.clear
      print_title(title, options[:default])
      values = Hash.new
      selection.each_with_index do |value,i|
        values[i.to_i] = value[1]
        if options[:number]
          Device::Display.print("#{i+1} - #{value[0]}", i+2, 0)
        else
          Device::Display.print(value[0], i+2, 0)
        end
      end

      key = getc(options[:timeout] || Device::IO.timeout)

      return options[:default] if key == Device::IO::ENTER || key == Device::IO::CANCEL
      [values[key.to_i - 1]].flatten.first
    end

    def number_to_currency(value, options = {})
      options[:delimiter] ||= ","
      options[:precision] ||= 2
      options[:separator] ||= "."

      if value.is_a? Float
        number, unit = value.to_s.split(".")
        unit = unit.to_s
        len = number.size + unit.size
      else
        len    = value.to_s.size
        unit   = value.to_s[(len - options[:precision])..-1]
        if len <= options[:precision]
          number = ""
        else
          number = value.to_s[0..(len - (options[:precision] + 1)).abs]
        end
      end

      text = ""
      i = 0
      number.reverse.each_char do |ch|
        i += 1
        text << ch
        text << options[:delimiter] if (i % 3 == 0) && (len - unit.size) != i
      end
      currency = [rjust(text.reverse, 1, "0"),rjust(unit, options[:precision], "0")].join options[:separator]
      if options[:label]
        options[:label] + currency
      else
        currency
      end
    end

    def ljust(string, size, new_string)
      string_plain = string.to_s
      if size > string_plain.size
        string_plain + (new_string * (size - string_plain.size))
      else
        string_plain
      end
    end

    def rjust(string, size, new_string)
      string_plain = string.to_s
      if size > string_plain.size
        (new_string * (size - string_plain.size)) + string_plain
      else
        string_plain
      end
    end

    private
    def form_default(options = {})
      options[:default] ||= ""
      options[:mode]    ||= Device::IO::IO_INPUT_LETTERS
      options[:min]     ||= 0
      options[:max]     ||= 20
      options
    end

    def print_title(string, default)
      if default
        puts("#{string} (#{default}):")
      else
        puts("#{string}:")
      end
    end
  end

end

