
class Device
  class Network

    MEDIA_GPRS = :gprs
    MEDIA_WIFI = :wifi

    class << self
      attr_accessor :type, :apn, :user, :password, :socket
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

    def self.get_ip
      adapter.get_ip if adapter.respond_to? :get_ip
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
      puts "Net Init #{Device::Network.init(*self.config)}"
      puts "Net Connnect #{Device::Network.connect}"
      puts "Net Connected? #{iRet = Device::Network.connected?}"
      while(iRet == 1) # 1 - In process to attach
        print iRet = Device::Network.connected?
      end
      puts Device::Network.get_ip
      iRet
    end

    def self.config
      media = Device::Setting.gprs? ? MEDIA_GPRS : MEDIA_WIFI
      [media, self.config_media(media) ]
    end

    # TODO should check if WIFI, ETHERNET and etc
    def self.config_media(media)
      if media == MEDIA_GPRS
        {
          apn:      Device::Setting.apn,
          user:     Device::Setting.user,
          password: Device::Setting.password
        }
      else
        {
          authentication: Device::Setting.authentication,
          password:       Device::Setting.password,
          essid:          Device::Setting.essid,
          channel:        Device::Setting.channel,
          cipher:         Device::Setting.cipher,
          mode:           Device::Setting.mode
        }
      end
    end
  end
end

