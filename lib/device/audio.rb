
class Device
  class Audio
    def self.adapter
      Device.adapter::Audio
    end

    # Play beep
    #
    # @param tone [Fixnum] 0 to 6
    # @param miliseconds [Fixnum] beep duration in miliseconds
    # @return [nil]
    def self.beep(tone, miliseconds)
      adapter.beep(tone, miliseconds)
    end
  end
end