class Device
  class System
    def self.adapter
      Device.adapter::System
    end

    def self.backlight
      adapter.backlight
    end

    def self.batery
      adapter.batery
    end

    def self.beep
      adapter.beep
    end

    def self.restart
      adapter.restart
    end

    def self.app
      adapter.app
    end

    def self.serial
      adapter.serial
    end

    def self.model
      adapter.model
    end
  end
end
