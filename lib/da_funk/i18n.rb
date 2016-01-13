class I18n
  include DaFunk::Helper
  class << self
    attr_accessor :locale, :hash, :block_parse
  end

  self.block_parse = Proc.new do |hash_,values_|
    if values_[1].is_a?(Hash)
      hash_[values_[0]] = values_[1].inject({}, &block_parse)
    else
      hash_[values_[0].to_sym] = values_[1]
    end
    hash_
  end

  def self.filepath(klass)
    "./#{klass}/i18n.json"
  end

  def self.configure(klass, locale)
    raise I18nError.new("File not found") if (! File.exists?(filepath(klass)))
    @hash   = JSON.parse(File.read(filepath(klass))).inject({}, &block_parse)
    @locale = locale
    raise I18nError.new("Locale not found") unless language
  end

  def self.language
    @hash[@locale]
  end

  def self.t(symbol, options = {})
    if ! options[:time].nil?
      parse_time(language[symbol], options[:time])
    elsif options[:args].nil?
      language[symbol]
    else
      language[symbol] % options[:args]
    end
  end

  def self.pt(symbol)
    puts(t(symbol))
  end

  def self.parse_time(value, time)
    value.sub("yy", time.year.to_s).
      sub("y", time.year.to_s[2..3]).
      sub("M", rjust(time.month.to_s, 2, "0")).
      sub("d", rjust(time.day.to_s, 2, "0")).
      sub("h", rjust(time.hour.to_s, 2, "0")).
      sub("m", rjust(time.min.to_s, 2, "0")).
      sub("s", rjust(time.sec.to_s, 2, "0"))
  end
end

