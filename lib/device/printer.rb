class Device
  class Printer
    # Same as print, but add "\n" at end of print
    #
    # @param buf [String] Text to be printed.
    # @param option [Symbol] :big, :bar_code, :bitmap
    # @return [String] buffer read from keyboard
    def self.puts(buf, option=nil); end

    # Print buffer
    #
    # @param buf [String] Text to be printed.
    # @param option [Symbol] :big, :bar_code, :bitmap
    # @return [String] buffer read from keyboard
    def self.print(buf, option=nil); end

    def self.paper?; end
    def self.paperfeed; end
  end
end
