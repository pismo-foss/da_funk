
class Device
  class Network

    MEDIA_GPRS = :gprs

    class << self
      attr_accessor :type, :apn, :user, :pass, :socket
    end

    def adapter
      Device.adapter::Network
    end

    def self.init(type, options)
      adapter.init(type, options)
    end

    def self.power(command)
      adapter.power(command)
    end

    def self.connect
      adapter.send(__method__)
    end

    def self.connected?
      adapter.send(__method__)
    end

    def self.ping(host, port)
      adapter.send(__method__, host, port)
    end

    def self.disconnect
      adapter.send(__method__)
    end

    def self.handshake
      handshake = "#{Device::System.serial};#{Device::System.app};#{Device::Setting.logical_number};#{Device.version}"
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

    def self.attach
      Device::Network.init(MEDIA_GPRS, self.config)
      Device::Network.connect
      while(iRet == 1)
        iRet = Device::Network.connected?
      end
    end

    def self.config
      # TODO should check if WIFI, ETHERNET and etc
      {
        apn: Setting::Network.apn,
        user: Setting::Network.user,
        pass: Setting::Network.pass
      }
    end
  end
end

