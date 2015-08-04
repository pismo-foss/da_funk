
class Device
  class Network

    MEDIA_GPRS     = "gprs"
    MEDIA_WIFI     = "wifi"
    MEDIA_ETHERNET = "ethernet"

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
      attr_accessor :type, :apn, :user, :password, :socket
    end

    self.socket = Proc.new do |avoid_handshake|
      sock = TCPSocket.new Device::Setting.host, Device::Setting.host_port
      sock.connect(avoid_handshake)
      sock
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

    def self.configured?
      Device::Setting.network_configured == "1"
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

    def self.attach
      Device::Network.init(*self.config)
      ret = Device::Network.connect
      ret = Device::Network.connected? if ret != SUCCESS
      while(ret == PROCESSING)
        ret = Device::Network.connected?
      end
      if ret == SUCCESS && (wifi? || ethernet?)
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
      elsif ethernet?
        Hash.new
      end
    end

    def self.gprs?
      Device::Setting.media == "gprs"
    end

    def self.wifi?
      Device::Setting.media == "wifi"
    end

    def self.ethernet?
      Device::Setting.media == "ethernet"
    end
  end
end

