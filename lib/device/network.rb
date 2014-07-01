class Device
  class Network
    class << self
      attr_accessor :type, :apn, :user, :pass, :socket
    end

    def self.init(type, options); end
    def self.power(command); end
    def self.connect; end
    def self.connected?; end
    def self.ping(host, port); end
    def self.disconnect; end
    def self.finish; end

    def self.handshake
      handshake = "#{Device::System.serial};#{Device::System.app};1;#{Device.version}"
      socket.write("#{handshake.size.chr}#{handshake}")

      company_name = socket.read(3)
      return false if company_name == "err"

      Device::Setting.company_name = company_name
      true
    end

    # Create Socket in Walk Switch
    def self.walk_socket
      unless (@socket && ! @socket.closed?)
        @socket = TCPSocket.new(Device::Setting.host, Device::Setting.host_port)
        handshake
        @socket
      end
    end
  end
end

