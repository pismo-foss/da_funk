class Device
  class IO < ::IO
    # The same as getc, but wait until eot be pressed
    #
    # @param eot [String] End Of Line, expected to return to return.
    # @return [String] buffer read from keyboard
    def self.gets(eot = "\n"); super; end

    # Read 1 byte on keyboard, wait until be pressed
    #
    # @return [String] key read from keyboard
    def self.getc; super; end

    # Read Track 1, 2, and 3 if available on card
    #
    # @return [Hash] key read from keyboard
    def self.read_card; super; end

    # Clean Display
    #
    # @return [nil]
    def self.display_clear; super; end
  end
end

