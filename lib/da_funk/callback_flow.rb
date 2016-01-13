module DaFunk
  class CallbackFlow
    attr_accessor :next
    attr_reader :block, :before, :bind

    def initialize(bind, callback, &block)
      @bind   = bind
      @block  = block
      @before = callback
      callback.next = self if callback
    end

    def dispatch(result)
      return if result.nil?
      Device::Display.clear
      route(check(bind.instance_exec(result, &block)))
    end

    def check(value)
      unless [true, nil, false].include?(value)
        value = check_keyboard(value)
      end
      value
    end

    def route(result)
      if result
        if @next
          @next.dispatch(result)
        else
          true
        end
      elsif result.nil?
      else
        @before.dispatch(true)
      end
    end

    private
    def check_keyboard(value)
      case value
      when Device::IO::CANCEL; return nil
      when Device::IO::BACK; return false
      when Device::IO::ENTER; return true
      end
      true
    end
  end
end

