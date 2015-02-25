module Zip
  def self.compress(*args)
    Miniz.zip(*args)
  end

  def self.uncompress(filezip, path = ".")
    dir = "#{path}/#{filezip.split(".")[0]}"
    clean(dir)
    Miniz.unzip(filezip, path)
  end

  def self.clean(dir)
    # TODO Refactor file check
    if Dir.exist?(dir)
      files = Dir.entries(dir)
      if (files.size > 2)
        files[2..-1].each do |file|
          if File.file?("#{dir}/#{file}")
            File.delete("#{dir}/#{file}")
          else
            Dir.delete("#{dir}/#{file}")
          end
        end
      end
      Dir.delete(dir)
    end
    Dir.mkdir(dir)
  end
end
