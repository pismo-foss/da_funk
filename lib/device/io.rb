class Device
  class IO < ::IO
    F1               = "\001"
    F2               = "\002"
    F3               = "\003"
    F4               = "\004"
    FUNC             = "\006"
    UP               = "\007"
    DOWN             = "\008"
    MENU             = "\009"
    ENTER            = 0x0D.chr
    CLEAR            = 0x0F.chr
    ALPHA            = 0x10.chr
    SHARP            = 0x11.chr
    KEY_TIMEOUT      = 0x12.chr
    BACK             = "\017"
    CANCEL           = 0x1B.chr
    IO_INPUT_NUMBERS = :numbers
    IO_INPUT_LETTERS = :letters
    IO_INPUT_SECRET  = :secret
    IO_INPUT_DECIMAL = :decimal
    IO_INPUT_MONEY   = :money

    NUMBERS = %w(1 2 3 4 5 6 7 8 9 0)

    include Device::Helper

    # Restricted to terminals, get strings and numbers.
    # The switch method between uppercase, lowercase and number characters is to keep pressing a same button quickly. The timeout of this operation is 1 second.
    #
    # @param min [Fixnum] Minimum length of the input string.
    # @param max [Fixnum] Maximum length of the input string (127 bytes maximum).
    # @param options [Hash]
    #
    # :precision - Sets the level of precision (defaults to 2).
    #
    # :separator - Sets the separator between the units (defaults to “.”).
    #
    # :delimiter - Sets the thousands delimiter (defaults to “,”).
    #
    # :label - Sets the label display before currency, eg.: "U$:", "R$:"
    #
    # :mode - Define input modes:
    #
    #   :numbers (IO_INPUT_NUMBERS) - Only number.
    #   :letters (IO_INPUT_LETTERS) - Letters and numbers.
    #   :secret (IO_INPUT_SECRET) - Secret *.
    #   :decimal (IO_INPUT_DECIMAL) - Decimal input, only number.
    #   :money (IO_INPUT_MONEY) - Money input, only number.
    #
    # @return [String] buffer read from keyboard
    def self.get_format(min, max, options = {})
      options[:mode] ||= IO_INPUT_LETTERS
      if options[:mode] == IO_INPUT_MONEY || options[:mode] == IO_INPUT_DECIMAL

        text = ""
        key = ""

        while key != CANCEL
          Device::Display.clear 2
          Device::Display.print_line number_to_currency(text, options), 2, 0
          key = getc
          if key == BACK
            text = text[0..-2]
          elsif text.size >= max
            next
          elsif NUMBERS.include? key
            text << key
          elsif key == ENTER
            return text
          end
        end
      else
        get_string(min, max, options[:mode])
      end
    end

    # Read 1 byte on keyboard, wait until be pressed
    #
    # @param timeout [Fixnum] Timeout in milliseconds to wait for key.
    #
    # @return [String] key read from keyboard
    def self.getc(timeout = 0); super(timeout); end
  end
end

