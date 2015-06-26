
class Device
  API_VERSION="0.4.6"

  def self.api_version
    Device::API_VERSION
  end

  def self.version
    adapter.version
  end
end

