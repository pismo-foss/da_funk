class Platform
  def self.start
    # ...
  end
end

class Device
  self.adapter = Platform
end