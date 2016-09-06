class Device
  class Magnetic
    def self.adapter
      Device.adapter::Magnetic
    end

    def adapter
      Device.adapter::Magnetic
    end

    def self.read_card(timeout)
      time = Time.now + (timeout.to_f / 1000.0)
      magnetic = self.new
      loop do
        break if magnetic.swiped? || time <= Time.now
      end
      magnetic.tracks
    ensure
      magnetic.close if magnetic
    end

    HARDWARE_RET_OK          = 0
    HARDWARE_SUCCESSFUL_READ = 1
    HARDWARE_NOT_READ        = 0
    STATUS_SUCCESSFUL_READ = :success
    STATUS_READ_TRACKS     = :read
    STATUS_CLOSE           = :close
    STATUS_OPEN            = :open
    STATUS_OPEN_FAIL       = :open_fail

    attr_reader :tracks, :track1, :track2, :track3, :status

    def initialize
      @status = STATUS_CLOSE
      @open = self.start
    end

    def start
      if self.adapter.open == HARDWARE_RET_OK
        @status = STATUS_OPEN
        true
      else
        @status = STATUS_OPEN_FAIL
        false
      end
    end

    def swiped?
      if self.read == HARDWARE_SUCCESSFUL_READ
        @status = STATUS_SUCCESSFUL_READ
        return true
      end
      false
    end

    def read?
      @status == STATUS_SUCCESSFUL_READ
    end

    def read
      adapter.read
    end

    def close
      adapter.close
    end

    def tracks
      read_tracks unless @tracks
      @tracks
    end

    def open?
      @open
    end

    def bin?(value)
      return false if value.to_s.empty?
      tracks if self.read?

      digits = track2.to_s[0..3]
      if value.is_a?(Range) && ! digits.empty? && digits.integer?
        value.include? digits.to_f
      else
        digits.to_s == value.to_s
      end
    end

    private
    def read_tracks
      @tracks = adapter.tracks
      @track1 = @tracks[:track1]
      @track2 = @tracks[:track2]
      @track3 = @tracks[:track3]

      @status = STATUS_READ_TRACKS
      @tracks
    end
  end
end
