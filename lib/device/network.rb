
class Device
  class Network

    MEDIA_GPRS = "gprs"
    MEDIA_WIFI = "wifi"

    AUTH_NONE_OPEN       = "open"
    AUTH_NONE_WEP        = "wep"
    AUTH_NONE_WEP_SHARED = "wepshared"
    AUTH_IEEE8021X       = "IEEE8021X"
    AUTH_WPA_PSK         = "wpapsk"
    AUTH_WPA_WPA2_PSK    = "wpawpa2psk"
    AUTH_WPA2_PSK        = "wpa2psk"

    PARE_CIPHERS_NONE   = "none"
    PARE_CIPHERS_WEP64  = "wep64"
    PARE_CIPHERS_WEP128 = "wep128"
    PARE_CIPHERS_WEPX   = "wepx"
    PARE_CIPHERS_CCMP   = "ccmp"
    PARE_CIPHERS_TKIP   = "tkip"

    MODE_IBSS    = "ibss"
    MODE_STATION = "station"

    TIMEOUT       = -3320
    NO_CONNECTION = -1012
    SUCCESS       = 0
    PROCESSING    = 1

    # Not Supported
    #AUTH_WPA_EAP        = "wpa_eap"
    #AUTH_WPA2_EAP       = "wpa2_eap"
    #AUTH_WPA_WPA2_EAP   = "wpa_wpa2_eap"

    class << self
      attr_accessor :type, :apn, :user, :password, :socket, :socket_tcp, :socket_ssl, :ssl
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
      return NO_CONNECTION unless self.adapter.started?
      adapter.connected?
    end

    def self.ping(host, port)
      adapter.ping(host, port)
    end

    def self.disconnect
      adapter.disconnect
    end

    def self.dhcp_client(timeout)
      time = Time.now + (timeout.to_f / 1000.0)
      ret = adapter.dhcp_client_start
      if (ret == SUCCESS)
        ret = PROCESSING
        while(ret == PROCESSING) # 1 - In process to attach
          ret = adapter.dhcp_client_check
          break ret = TIMEOUT unless (time >= Time.now)
        end
      end
      ret
    end

    def self.handshake_ssl!
      @socket_ssl = self.handshake_ssl(@socket_tcp)
      @ssl = true
      @socket = @socket_ssl
    end

    def self.handshake_ssl(tcp)
      entropy = PolarSSL::Entropy.new
      ctr_drbg = PolarSSL::CtrDrbg.new entropy
      s_ssl = PolarSSL::SSL.new
      s_ssl.set_endpoint PolarSSL::SSL::SSL_IS_CLIENT
      s_ssl.set_rng ctr_drbg
      s_ssl.set_socket tcp
      s_ssl.handshake
      s_ssl
    end

    def self.handshake!
      handshake = "#{Device::System.serial};#{Device::System.app};#{Device::Setting.logical_number};#{Device.version}"
      socket.write("#{handshake.size.chr}#{handshake}")

      company_name = socket.read(3)
      return false if company_name == "err" || company_name.nil?

      Device::Setting.company_name = company_name
      true
    end

    # Create Socket in Walk Switch
    def self.walk_socket
      if @socket
        @socket
      else
        @socket_tcp = create_socket
        if Device::Setting.ssl == "1"
          handshake_ssl!
        else
          @socket = @socket_tcp
        end
        handshake!
        @socket
      end
    end

    def self.create_socket
      TCPSocket.new(Device::Setting.host, Device::Setting.host_port)
    end

    def self.close_socket
      @socket.close
      if @socket != @socket_tcp
        @socket_tcp.close
      end
      @socket     = nil
      @socket_tcp = nil
      @socket_ssl = nil
    end

    def self.attach
      Device::Network.init(*self.config)
      ret = Device::Network.connect
      ret = Device::Network.connected? if ret != SUCCESS
      while(ret == PROCESSING)
        ret = Device::Network.connected?
      end
      if ret == SUCCESS && wifi?
        Device::Network.dhcp_client(20000)
      end
      ret
    end

    def self.config
      # TODO raise some error if media was not set
      [Device::Setting.media, self.config_media]
    end

    # TODO should check if WIFI, ETHERNET and etc
    def self.config_media
      if gprs?
        {
          apn:      Device::Setting.apn,
          user:     Device::Setting.user,
          password: Device::Setting.password
        }
      elsif wifi?
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

    def self.gprs?
      Device::Setting.media == "gprs"
    end

    def self.wifi?
      Device::Setting.media == "wifi"
    end
  end
end

