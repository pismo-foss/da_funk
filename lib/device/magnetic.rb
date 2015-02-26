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
      self.start
    end

    def start
      if self.adapter.open == 1
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
