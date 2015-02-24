class Device
  class Notification
    DEFAULT_TIMEOUT = 15

    class << self
      attr_accessor :callbacks, :current
    end
    self.callbacks = []

    attr_reader :fiber, :timeout


    def self.execute(event)
      calls = self.callbacks[event.callback]
      [:before, :on, :after].each do |moment|
        calls.each{|callback| callback.call(event, moment)}
      end
    end

    def self.schedule(callback)
      self.callbacks[callback.description] ||= []
      self.callbacks[callback.description] << callback
    end

    def self.setup
      NotificationCallback.new "APP_UPDATE", :on => Proc.new do
      end

      NotificationCallback.new "SETUP_DEVICE_CONFIG", :on => Proc.new do
      end

      NotificationCallback.new "RESET_DEVICE_CONFIG", :on => Proc.new do
      end

      NotificationCallback.new "SYSTEM_UPDATE", :on => Proc.new { |file| }

      NotificationCallback.new "CANCEL_SYSTEM_UPDATE", :on => Proc.new {}
    end

    def initialize(timeout = DEFAULT_TIMEOUT)
      @timeout = timeout
      Device::Notification.current = self
      @fiber = create_fiber
    end

    # Check if there is any notification
    def check
      if @fiber.alive? && (notification = @fiber.resume)
        Notification.execute(NotificationEvent.new(notification))
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
