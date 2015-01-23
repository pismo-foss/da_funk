class Device
  class IO < ::IO
    CANCEL           = 0x1B.chr
    ENTER            = 0x0D.chr
    BACK             = "\017"
    F1               = "\020"
    F2               = "\002"
    IO_INPUT_NUMBERS = :numbers
    IO_INPUT_LETTERS = :letters
    IO_INPUT_SECRET  = :secret
    IO_INPUT_DECIMAL = :decimal
    IO_INPUT_MONEY   = :money

    NUMBERS = %w(1 2 3 4 5 6 7 8 9 0)

    class << self
      include Device::Helper
    end

    # Restricted to terminals, get strings and numbers.
    # The switch method between uppercase, lowercase and number characters is to keep pressing a same button quickly. The timeout of this operation is 1 second.
    #
    # @param min [Fixnum] Minimum length of the input string.
    # @param max [Fixnum] Maximum length of the input string (127 bytes maximum).
    # @param mode [Symbol] Indicate the type of input
    #
    # :numbers (IO_INPUT_NUMBERS) - Only number.
    #
    # :letters (IO_INPUT_LETTERS) - Letters and numbers.
    #
    # :secret (IO_INPUT_SECRET) - Secret *.
    #
    # :decimal (IO_INPUT_DECIMAL) - Decimal input, only number.
    #
    # :money (IO_INPUT_MONEY) - Money input, only number.
    #
    # @param options [Hash]
    #
    # :precision - Sets the level of precision (defaults to 2).
    #
    # :unit - Sets the denomination of the currency (defaults to “$”).
    #
    # :separator - Sets the separator between the units (defaults to “.”).
    #
    # :delimiter - Sets the thousands delimiter (defaults to “,”).
    #
    # @return [String] buffer read from keyboard
    def self.get_string(min, max, options = {})
      options[:mode] ||= IO_INPUT_LETTERS
      if options[:mode] == IO_INPUT_MONEY || options[:mode] == IO_INPUT_DECIMAL
        options[:delimiter] ||= ","
        options[:separator] ||= "."
        options[:precision] ||= 2

        text = ""
        key = ""

        while key != CANCEL
          Device::Display.clear 2
          Device::Display.print_line number_to_currency(text, options), 2, 0
          key = getc
          if key == BACK
            text = text[0..-2]
          elsif NUMBERS.include? key
            text << key
          elsif key == ENTER
            return text
          end
        end
      else
        super(min, max, options[:mode])
      end
    end

    # The same as getc, but wait until eot be pressed
    #
    # @param separator [String] Separator, expected to return to return.
    # @param limit [Fixnum] Limit of characters.
    # @return [String] buffer read from keyboard
    def self.gets(separator, limit, mode = IO_INPUT_LETTERS); super; end

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

