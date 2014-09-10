
class FileDb
  attr_accessor :path, :hash

  def initialize(path, default_value)
    @hash = default_value.dup
    @path = path
    self.open
  end

  def open
    if File.exist?(@path)
      file = File.open(@path, "r")
      self.parse(file.read)
    end
  ensure
    file.close if file
  end

  def parse(text)
    text.each_line do |line|
      line = line[0..-2] if line[-1] == "\n" # Last record, probably shouldn't have \n
      key_value = line.split("=")
      @hash[key_value[0]] ||= key_value[1]
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
end
