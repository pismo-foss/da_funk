module DaFunk
  class Engine
    def self.setup
      Device::Display.clear
      puts "SETUP NOTIFICATIONS..."
      Device::Notification.setup
    end

    def self.check
      Device::Notification.check
      DaFunk::Helper::StatusBar.check
    end
  end
end

