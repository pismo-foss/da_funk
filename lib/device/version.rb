
class Device
  def self.api_version
    "0.2.0"
  end

  def self.version
    adapter.version
  end
end

