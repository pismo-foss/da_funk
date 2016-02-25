module DaFunk
  module Helper
    class StatusBar
      STATUS_TIMEOUT  = 10
      SLOT_CONNECTION = 0
      SLOT_BATTERY    = 7

      BATTERY_IMAGES = {
        0 => "./shared/battery0.png",
        1 => "./shared/battery25.png",
        2 => "./shared/battery50.png",
        3 => "./shared/battery75.png",
        4 => "./shared/battery100.png",
        5 => "./shared/battery0c.png",
        6 => "./shared/battery100c.png",
        7 => nil
      }

      WIFI_IMAGES = {
        0..29   => "./shared/wifi0.png",
        30..59  => "./shared/wifi30.png",
        60..79  => "./shared/wifi60.png",
        80..100 => "./shared/wifi100.png"
      }

      MOBILE_IMAGES = {
        0..0    => "./shared/mobile0.png",
        1..20   => "./shared/mobile20.png",
        21..40  => "./shared/mobile40.png",
        41..60  => "./shared/mobile60.png",
        61..80  => "./shared/mobile80.png",
        81..100 => "./shared/mobile100.png"
      }

      class << self
        attr_accessor :status_timeout, :signal, :battery
      end

      def self.check
        if self.valid?
          self.change_connection
          self.change_battery
        end
      end

      def self.change_connection
        sig = Device::Network.signal
        if self.signal != sig
          self.signal = sig
          if Device::Network.gprs?
            Device::Display.print_status_bar(SLOT_CONNECTION,
                                             get_image_path(:gprs, self.signal))
          elsif Device::Network.wifi?
            Device::Display.print_status_bar(SLOT_CONNECTION,
                                             get_image_path(:wifi, self.signal))
          end
        end
      end

      def self.change_battery
        bat = Device::System.battery
        if self.battery != bat
          self.battery = bat
          Device::Display.print_status_bar(
            SLOT_BATTERY, get_image_path(:battery, self.battery))
        end
      end

      def self.get_image_path(type, sig)
        return if sig.nil?
        case type
        when :gprs
          MOBILE_IMAGES.each {|k,v| return v if k.include? sig }
        when :wifi
          WIFI_IMAGES.each {|k,v| return v if k.include? sig }
        when :battery
          BATTERY_IMAGES[sig]
        else
          nil
        end
      end

      self.status_timeout ||= Time.now
      def self.valid?
        if self.status_timeout < Time.now
          self.status_timeout = Time.now + STATUS_TIMEOUT
          true
        end
      end
    end
  end
end

