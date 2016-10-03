module DaFunk
  class EventHandler
    attr_reader :option, :type
    attr_accessor :timer

    def initialize(type, option, &block)
      @type          = type
      @option        = option
      @perform_block = block
      self.register
    end

    def register
      self.schedule_timer
      EventListener.add_handler(self)
    end

    def perform(*parameter)
      self.schedule_timer
      @perform_block.call(*parameter)
    end

    def schedule_timer
      if self.option.is_a?(Hash)
        if self.option.include?(:minutes)
          self.timer = Time.now + (self.option[:minutes].to_i * 60)
        elsif self.option.include?(:seconds)
          self.timer = Time.now + self.option[:seconds]
        end
      end
    end

    def execute?
      self.timer < Time.now if self.timer
    end
  end
end

