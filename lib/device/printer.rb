class Device
  class Printer
    def self.adapter
      Device.adapter::Printer
    end

    # Same as print, but add "\n" at end of print
    #
    # @param buf [String] Text to be printed.
    # @param option [Symbol] :big, :bar_code, :bitmap
    # @return [String] buffer read from keyboard
    def self.puts(buf, option=nil)
      adapter.puts(buf, option)
    end

    # Print buffer
    #
    # @param buf [String] Text to be printed.
    # @param option [Symbol] :big, :bar_code, :bitmap
    # @return [String] buffer read from keyboard
    def self.print(buf, option=nil)
      adapter.print(buf, option)
    end

    def self.paper?
      adapter.paper?
    end

    def self.paperfeed
      adapter.paperfeed
    end
  end
end
