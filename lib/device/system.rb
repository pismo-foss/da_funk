
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

    # Read the battery level.
    #  0 Battery voltage low and battery icon blinks. Suggested that do not process transaction, print and wireless communication etc. at this moment. You should recharge the battery immediately to avoid shut down and lost data.
    #  1 Battery icon displays 1 grid
    #  2 Battery icon displays 2 grids
    #  3 Battery icon displays 3 grids
    #  4 Battery icon displays 4 grids
    #  5 Powered by external power supply and the battery in charging. Battery icon displays form empty to full cycle. The battery status indicator on the bottom of terminal is displaying red
    # ￼6 Powered by external power supply and the battery charging 6 finished. Battery icon displays full grids. The battery status indicator on the bottom of terminal is displaying green.
    def self.battery
      adapter.battery
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

