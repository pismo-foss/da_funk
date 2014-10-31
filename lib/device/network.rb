
class Device
  class Network

    MEDIA_GPRS = :gprs
    MEDIA_WIFI = :wifi

    class << self
      attr_accessor :type, :apn, :user, :pass, :socket
    end

    def self.adapter
      Device.adapter::Network
    end

    def self.init(type, options)
      adapter.init(type, options)
    end

    def self.power(command)
      adapter.power(command)
    end

    def self.connect
      adapter.connect
    end

    def self.connected?
      adapter.connected?
    end

    def self.ping(host, port)
      adapter.ping(host, port)
    end

    def self.disconnect
      adapter.disconnect
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
      if @socket && ! @socket.closed?
        @socket
      else
        @socket = TCPSocket.new(Device::Setting.host, Device::Setting.host_port)
        handshake
        @socket
      end
    end

    def self.attach
      "Net Init #{Device::Network.init(MEDIA_GPRS, self.config)}"
      "Net Connnect #{Device::Network.connect}"
      "Net Connected? #{iRet = Device::Network.connected?}"
      while(iRet == 1) # 1 - In process to attach
        iRet = Device::Network.connected?
      end
      iRet
    end

    def self.config
      # TODO should check if WIFI, ETHERNET and etc
      {
        apn: Device::Setting.apn,
        user: Device::Setting.user,
        pass: Device::Setting.pass
      }
    end
  end
end

