module PosxmlParser
  module Threadable
    if Object.const_defined?(:Thread)
      ENGINE=Thread
    elsif Object.const_defined?(:Fiber)
      ENGINE=Fiber
    else
      ENGINE=nil
    end

    attr_accessor :thread

    def posxml_execute_thread(blocking = false, &block)
      @posxml_threads ||= []
      if thread && Threadable::ENGINE
        @posxml_threads << Threadable::ENGINE.new do
          result = block.call
          posxml_wait_thread if blocking
          result
        end
      else
        block.call
      end
    end

    def posxml_wait_thread
      return unless @posxml_threads
      loop do
        @posxml_current_thread ||= @posxml_threads.delete_at(0)
        break unless @posxml_current_thread
        @posxml_current_thread = nil unless @posxml_current_thread.alive?
      end
    end

    def posxml_kill_all_threads
      return unless @posxml_threads
      @posxml_thread.each do |thread_to_kill|
        thread_to_kill.kill if thread_to_kill.alive?
      end
    end
  end
end
