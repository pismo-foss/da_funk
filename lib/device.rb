class Device
  class << self
    attr_accessor :adapter
  end

  # Flat syntax/behaviour API between versions, to any application be able to execute on whole versions.
  #
  # @return [Class] the class object flatted
  def self.flat_api
    klass_version = Device::VERSION.gsub(".", "")
    if Device::VERSION == "0.4.3"
      puts "#{Device.name}"
      const_get("VersionFlat#{klass_version}").flat Device
    end
  end
end

