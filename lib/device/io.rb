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
    IO_INPUT_ALPHA   = :alpha
    IO_INPUT_SECRET  = :secret
    IO_INPUT_DECIMAL = :decimal
    IO_INPUT_MONEY   = :money
    IO_INPUT_MASK    = :mask

    MASK_ALPHA       = :alpha
    MASK_LETTERS     = :letters
    MASK_NUMBERS     = :number

    DEFAULT_TIMEOUT  = 30000

    NUMBERS = %w(1 2 3 4 5 6 7 8 9 0)

    ONE_LETTERS   = "qzQZ _,."
    TWO_LETTERS   = "abcABC"
    THREE_LETTERS = "defDEF"
    FOUR_LETTERS  = "ghiGHI"
    FIVE_LETTERS  = "jklJKL"
    SIX_LETTERS   = "mnoMNO"
    SEVEN_LETTERS = "prsPRS"
    EIGHT_LETTERS = "tuvTUV"
    NINE_LETTERS  = "wxyWXY"
    ZERO_LETTERS  = "spSP"

    ONE_NUMBER    = "1"
    TWO_NUMBER    = "2"
    THREE_NUMBER  = "3"
    FOUR_NUMBER   = "4"
    FIVE_NUMBER   = "5"
    SIX_NUMBER    = "6"
    SEVEN_NUMBER  = "7"
    EIGHT_NUMBER  = "8"
    NINE_NUMBER   = "9"
    ZERO_NUMBER   = "0"

    ONE_ALPHA     = ONE_NUMBER   + ONE_LETTERS
    TWO_ALPHA     = TWO_NUMBER   + TWO_LETTERS
    THREE_ALPHA   = THREE_NUMBER + THREE_LETTERS
    FOUR_ALPHA    = FOUR_NUMBER  + FOUR_LETTERS
    FIVE_ALPHA    = FIVE_NUMBER  + FIVE_LETTERS
    SIX_ALPHA     = SIX_NUMBER   + SIX_LETTERS
    SEVEN_ALPHA   = SEVEN_NUMBER + SEVEN_LETTERS
    EIGHT_ALPHA   = EIGHT_NUMBER + EIGHT_LETTERS
    NINE_ALPHA    = NINE_NUMBER  + NINE_LETTERS
    ZERO_ALPHA    = ZERO_NUMBER  + ZERO_LETTERS

    RANGE_ALPHA   = [ONE_ALPHA, TWO_ALPHA, THREE_ALPHA, FOUR_ALPHA, FIVE_ALPHA, SIX_ALPHA, SEVEN_ALPHA, EIGHT_ALPHA, NINE_ALPHA, ZERO_ALPHA]
    RANGE_NUMBER  = [ONE_NUMBER, TWO_NUMBER, THREE_NUMBER, FOUR_NUMBER, FIVE_NUMBER, SIX_NUMBER, SEVEN_NUMBER, EIGHT_NUMBER, NINE_NUMBER, ZERO_NUMBER]
    RANGE_LETTERS = [ONE_LETTERS, TWO_LETTERS, THREE_LETTERS, FOUR_LETTERS, FIVE_LETTERS, SIX_LETTERS, SEVEN_LETTERS, EIGHT_LETTERS, NINE_LETTERS, ZERO_LETTERS]

    KEYS_RANGE    = {MASK_ALPHA => RANGE_ALPHA, MASK_LETTERS => RANGE_LETTERS, MASK_NUMBERS => RANGE_NUMBER}

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
    # :mask - If mode IO_INPUT_MASK a mask should send
    #   (only numbers and letters are allowed), eg.: "9999-AAAA"
    #
    # :mode - Define input modes:
    #
    #   :numbers (IO_INPUT_NUMBERS) - Only number.
    #   :letters (IO_INPUT_LETTERS) - Only Letters.
    #   :alpha (IO_INPUT_ALPHA) - Letters and numbers.
    #   :secret (IO_INPUT_SECRET) - Secret *.
    #   :decimal (IO_INPUT_DECIMAL) - Decimal input, only number.
    #   :money (IO_INPUT_MONEY) - Money input, only number.
    #   :mask (IO_INPUT_MASK) - Custom mask.
    #
    # @return [String] buffer read from keyboard
    def self.get_format(min, max, options = {})
      set_default_format_option(options)
      key = text = ""

      while key != CANCEL
        Device::Display.clear options[:line]
        Device::Display.print_line format(text, options), options[:line], options[:column]
        key = getc
        if key == BACK
          text = text[0..-2]
        elsif key == ENTER || key == KEY_TIMEOUT
          return text
        elsif key ==  F1 || key == DOWN || key == UP
          change_next(text, check_mask_type(text, options))
          next
        elsif text.size >= max
          next
        elsif insert_key?(key, options)
          text << key
        end
      end
    end

    def self.set_default_format_option(options)
      options[:mode]   ||= IO_INPUT_LETTERS
      options[:line]   ||= 2
      options[:column] ||= 0

      if options[:mask]
        options[:mask_clean] = options[:mask].chars.reject{|ch| ch.match(/[^0-9A-Za-z]/) }.join
      end
    end

    def self.check_mask_type(text, options)
      if options[:mode] == Device::IO::IO_INPUT_ALPHA
        Device::IO::MASK_ALPHA
      elsif options[:mode] == Device::IO::IO_INPUT_LETTERS
        Device::IO::MASK_LETTERS
      elsif options[:mode] == Device::IO::IO_INPUT_MASK
        options[:mask_clean][text.length - 1].match(/[0-9]/) ? Device::IO::MASK_NUMBERS : Device::IO::MASK_LETTERS
      else
        Device::IO::MASK_ALPHA
      end
    end

    def self.change_next(text, mask_type = Device::IO::MASK_ALPHA)
      char = text[-1]
      if char && (range = KEYS_RANGE[mask_type].detect { |range| range.include?(char) })
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
      elsif options[:mode] == IO_INPUT_SECRET
        "*" * string.size
      elsif options[:mode] == IO_INPUT_MASK
        string.to_mask(options[:mask])
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

