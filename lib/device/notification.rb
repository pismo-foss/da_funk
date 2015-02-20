class Device
  class Notification
    DEFAULT_TIMEOUT = 15

    class << self
      attr_accessor :callbacks, :current
    end

    attr_accessor :events
    attr_reader :fiber, :timeout

    def self.setup
      # TODO Scalone event parse
      #self.callbacks = {
        #:on_system_update => Proc.new {|event| },
        #:on_app_update => Proc.new {|event| },
        #:on_ => Proc.new {|event| },
      #}
    end

    def initialize(timeout = DEFAULT_TIMEOUT)
      @timeout = timeout
      Device::Notification.current = self
      @fiber = create_fiber
    end

    # Check if there is any event
    def check
      if @fiber.alive?
        # TODO Scalone event parse
        event = @fiber.resume
      end
    end

    # Close socket and finish Fiber execution
    def close
      @fiber.resume "close"
    end

    def closed?
      ! @fiber.alive?
    end

    private
    def create_fiber
      Fiber.new do
        Serfx.connect(socket_block: socket_callback, timeout: timeout) do |conn|
          conn.stream("user:#{Device::Setting.company_name};#{Device::Setting.logical_number}")
        end
        true
      end
    end

    def socket_callback
      Proc.new do
        socket_tcp = Device::Network.create_socket
        socket_tcp.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)
        ssl = Device::Network.handshake_ssl(socket_tcp)
        [ssl, socket_tcp]
      end
    end
  end
end
