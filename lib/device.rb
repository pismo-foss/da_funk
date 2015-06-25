
class Device
  class << self
    attr_accessor :adapter
  end

  # Flat syntax/behaviour API between versions, to any application be able to execute on whole versions.
  #
  # @return [Class] the class object flatted
  def self.flat_api
    klass_version = Device.version.gsub(".", "")
    # Sample
    #if Device.version == "0.4.3"
      #const_get("VersionFlat#{klass_version}").flat Device
    #end
  end

  def self.call(*args)
  end

  def self.app_loop(&block)
    Notification.setup
    loop do
      Notification.check
      block.call(self)
    end
  end
end

