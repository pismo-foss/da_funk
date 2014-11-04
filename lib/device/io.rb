class Device
  class IO < ::IO
    CANCEL           = 0x1B.chr
    ENTER            = 0x0D.chr
    BACK             = 0x08.chr
    F1               = 0x01.chr
    F2               = 0x02.chr
    IO_INPUT_NUMBERS = :numbers
    IO_INPUT_LETTERS = :letters
    IO_INPUT_SECRET  = :secret

    # Restricted to terminals, get strings and numbers.
    # The switch method between uppercase, lowercase and number characters is to keep pressing a same button quickly. The timeout of this operation is 1 second.
    #
    # @param min [Fixnum] Minimum length of the input string.
    # @param max [Fixnum] Maximum length of the input string (127 bytes maximum).
    # @return [String] buffer read from keyboard
    def self.get_string(min, max); super; end

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
  end
end

