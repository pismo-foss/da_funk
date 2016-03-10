module DaFunk
  class EventHandler
    attr_reader :option, :type

    def initialize(type, option, &block)
      @type          = type
      @option        = option
      @perform_block = block
      self.register
    end

    def register
      EventListener.add_handler(self)
    end

    def perform(*parameter)
      @perform_block.call(*parameter)
    end
  end
end

