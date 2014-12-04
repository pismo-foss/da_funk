class Device
  class Runtime
    def self.adapter
      Device.adapter::Runtime
    end

    def self.execute(app)
      self.adapter.execute(app)
    end
  end
end
