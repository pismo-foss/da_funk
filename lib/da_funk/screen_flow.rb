module DaFunk
  class ScreenFlow
    attr_accessor :list

    def self.add(method, &block)
      define_method method do
        @list << CallbackFlow.new(self, @list.last, &block)
        self
      end
    end

    def initialize
      self.list = []
      order
    end

    def order
    end

    def start
      first = self.list.first
      first.dispatch(true) if first
    end

    def confirm(text)
      puts text.chomp
      getc(0)
    end
  end
end
