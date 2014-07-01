class Device
  # Flat syntax/behaviour API between versions, to any application be able to execute on whole versions.
  #
  # @return [Class] the class object flatted
  def self.flat_api
    klass_version = self::VERSION.gsub(".", "")
    if self::VERSION == "0.4.3"
      puts "#{self.name}"
      const_get("VersionFlat#{klass_version}").flat self
    end
  end
end

