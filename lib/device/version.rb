
class Device
  API_VERSION="0.6.1"

  def self.api_version
    Device::API_VERSION
  end

  def self.version
    adapter.version
  end
end

