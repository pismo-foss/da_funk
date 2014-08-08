
class Device
  class System
    class << self
      attr_reader :serial, :backlight
    end

    def self.adapter
      Device.adapter::System
    end

    def self.serial
      @serial ||= adapter.serial
    end

    # Set screen backlight (turn on automatically if there has actions like key-pressing, card-swiping or card-inserting).
    #  0 = Turn off backlight.
    #  1 = (D200): Keep backlight on for 30 seconds ( auto-shut-down after 30 seconds).
    #  1 = (Vx510): On.
    #  2 = (D200): Always on.
    #  n = (Evo/Telium 2): Percentage until 100.
    def self.backlight=(level)
      adapter.backlight = level
      @backlight = level
    end

    def self.backlight
      @backlight ||= adapter.backlight
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

    # TODO: Check file information on ruby compilers
    def self.app
      __FILE__
    end


    def self.model
      adapter.model
    end
  end
end

