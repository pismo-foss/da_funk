
class FileDb
  attr_accessor :path, :hash

  def initialize(path, default_value = {})
    @hash = default_value.dup
    @path = path
    self.open
  end

  def open
    if File.exist?(@path)
      file = File.open(@path)
      self.parse(file.read)
    end
  ensure
    file.close if file
  end

  def parse(text)
    text.split("\n").compact.each do |line|
      key_value = line.split("=")
      key, value = key_value[0].to_s.strip, key_value[1].to_s.strip
      if key_value[1] && (@hash[key].nil? || @hash[key].empty?)
        @hash[key] = value
      end
    end
  end

  def save
    file_new = File.open(@path, "w+")
    @hash.each do |line_key, line_value|
      file_new.puts("#{line_key}=#{line_value}")
    end
    file_new.close
  end

  def []=(key, value)
    ret = @hash[key] = value
    save
    ret
  end

  def [](key)
    @hash[key]
  end
end

