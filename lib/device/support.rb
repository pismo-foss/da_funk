class Device
  class Support
    def self.class_to_path(klass)
      klass.to_s.downcase
    end

    def self.path_to_class(path)
      constantize(camelize(remove_extension(path)))
    end

    def self.camelize(str)
      str.split('_').map {|w| w.capitalize}.join
    end

    def self.remove_extension(path)
      path.to_s.split(".")[-2].split("/").last
    end

    def self.constantize(name)
      if ! name.empty? && Object.const_defined?(name)
        Object.const_get name
      else
        nil
      end
    end
  end
end

