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

    DEFAULT_TIMEOUT  = 30000

    NUMBERS = %w(1 2 3 4 5 6 7 8 9 0)

    ONE   = "1qzQZ _,."
    TWO   = "2abcABC"
    THREE = "3defDEF"
    FOUR  = "4ghiGHI"
    FIVE  = "5jklJKL"
    SIX   = "6mnoMNO"
    SEVEN = "7prsPRS"
    EIGHT = "8tuvTUV"
    NINE  = "9wxyWXY"
    ZERO  = "0spSP"

    KEYS_RANGE = [ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO]

    include Device::Helper

    class << self
      attr_accessor :timeout
    end

    self.timeout = DEFAULT_TIMEOUT

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
      options[:mode]   ||= IO_INPUT_LETTERS
      options[:line]   ||= 2
      options[:column] ||= 0
      text = ""
      key = ""

      while key != CANCEL
        Device::Display.clear options[:line]
        Device::Display.print_line format(text, options), options[:line], options[:column]
        key = getc
        if key == BACK
          text = text[0..-2]
        elsif key == ENTER
          return text
        elsif key ==  F1 || key == DOWN || key == UP
          change_next(text) if (options[:mode] != IO_INPUT_MONEY) && (options[:mode] != IO_INPUT_DECIMAL)
          next
        elsif text.size >= max
          next
        elsif insert_key?(key, options)
          text << key
        end
      end
    end

    def self.change_next(text)
      char = text[-1]
      if range = KEYS_RANGE.detect { |range| range.include?(char) }
        index = range.index(char)
        new_value = range[index+1]
        if new_value
          text[-1] = new_value
        else
          text[-1] = range[0]
        end
      end
      text
    end

    # Read 1 byte on keyboard, wait until be pressed
    #
    # @param timeout [Fixnum] Timeout in milliseconds to wait for key.
    # If not sent the default timeout is 30_000.
    # If nil should be blocking.
    #
    # @return [String] key read from keyboard
    def self.getc(timeout = self.timeout); super(timeout); end

    def self.format(string, options)
      if options[:mode] == IO_INPUT_MONEY || options[:mode] == IO_INPUT_DECIMAL
        number_to_currency(string, options)
      #elsif options[:mode] == IO_INPUT_LETTERS
      elsif options[:mode] == IO_INPUT_SECRET
        "*" * string.size
      else
        string
      end
    end

    def self.insert_key?(key, options)
      if options[:mode] == IO_INPUT_MONEY || options[:mode] == IO_INPUT_DECIMAL || options[:mode] == IO_INPUT_NUMBERS
        NUMBERS.include?(key)
      elsif options[:mode] != IO_INPUT_NUMBERS && options[:mode] != IO_INPUT_MONEY && options[:mode] != IO_INPUT_DECIMAL
        true
      else
        false
      end
    end
  end
end

