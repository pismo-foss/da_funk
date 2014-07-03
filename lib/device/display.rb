class Device
  class Display
    # Same as print, but add "\\n" at end of print
    #
    # @param buf [String] Text to be printed.
    # @param row [Fixnum] Row to start display.
    # @param column [Fixnum] Column to start display.
    # @return [String] buffer to display.
    def self.puts(buf, row = 0, column = 0); end

    # Display buffer
    #
    # @param buf [String] Text to be printed.
    # @param row [Fixnum] Row to start display.
    # @param column [Fixnum] Column to start display.
    # @return [String] buffer to display.
    def self.print(buf, row = 0, column = 0); end

    # Clean display
    def self.clear; end
  end
end
