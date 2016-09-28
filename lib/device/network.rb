
class Device
  class Network
    include DaFunk::Helper

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

    ERR_USER_CANCEL = -1010
    TIMEOUT         = -3320
    NO_CONNECTION   = -1012
    SUCCESS         = 0
    PROCESSING      = 1

    POWER_OFF = 0
    POWER_ON  = 1

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
      if self.adapter.started? ||
        (self.configured? && Device::Network.init(*self.config) == SUCCESS)

        return adapter.connected?
      end
      NO_CONNECTION
    end

    def self.configured?
      Device::Setting.network_configured == "1" && ! Device::Setting.media.to_s.empty?
    end

    def self.ping(host, port)
      adapter.ping(host, port)
    end

    def self.disconnect
      adapter.disconnect
    end

    def self.sim_id
      if self.adapter.started?
        adapter.sim_id
      end
    end

    # Check signal value
    #
    # @return [Fixnum] Signal value between 0 and 5.
    def self.signal
      if self.connected? == 0
        adapter.signal
      end
    end

    # Scan for wifi aps available
    #
    # @return [Array] Return an array of hash values
    #   containing the values necessary to configure connection
    #
    # @example
    #   aps = Device::Network.scan
    #   # create a selection to menu method
    #   selection = aps.inject({}) do |selection, hash|
    #     selection[hash[:essid]] = hash; selection
    #   end
    #   selected = menu("Select SSID:", selection)
    #
    #   Device::Setting.password       = form("Password",
    #     :min => 0, :max => 127, :default => Device::Setting.password)
    #   Device::Setting.authentication = selected[:authentication]
    #   Device::Setting.essid          = selected[:essid]
    #   Device::Setting.channel        = selected[:channel]
    #   Device::Setting.cipher         = selected[:cipher]
    #   Device::Setting.mode           = selected[:mode]
    def self.scan
      if wifi?
        adapter.scan if Device::Network.init(*self.config)
      end
    end

    def self.dhcp_client(timeout)
      ret = adapter.dhcp_client_start
      if (ret == SUCCESS)
        hash = try_user(timeout) do |processing|
          processing[:ret] = adapter.dhcp_client_check
          processing[:ret] == PROCESSING
        end
        ret = hash[:ret]

        unless ret == SUCCESS
          ret = ERR_USER_CANCEL if hash[:key] == Device::IO::CANCEL
        end
      end
      ret
    end

    def self.attach
      ret = Device::Network.connected?
      if ret != SUCCESS
        ret = Device::Network.init(*self.config)
        ret = Device::Network.connect
        ret = Device::Network.connected? if ret != SUCCESS

        hash = try_user do |process|
          process[:ret] = Device::Network.connected?
          process[:ret] == PROCESSING # if true keep trying
        end
        ret = hash[:ret]

        if ret == SUCCESS
          ret = Device::Network.dhcp_client(20000) if (wifi? || ethernet?)
          Device::Setting.network_configured = 1
        else
          ret = ERR_USER_CANCEL if hash[:key] == Device::IO::CANCEL
          Device::Setting.network_configured = 0
          Device::Network.disconnect
        end
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

