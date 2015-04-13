
class Device
  class Setting
    FILE_PATH       = "./main/config.dat"
    HOST_PRODUCTION = "switch.cloudwalk.io"
    HOST_STAGING    = "switch-staging.cloudwalk.io"

    DEFAULT     = {
      "host"                        => "switch-staging.cloudwalk.io",
      "host_port"                   => "31416",
      "ssl"                         => "1",
      "user"                        => "",
      "password"                    => "", #WIFI
      "apn"                         => "",
      "authentication"              => "", #WIFI
      "essid"                       => "", #WIFI
      "bssid"                       => "", #WIFI
      "cipher"                      => "", #WIFI
      "mode"                        => "", #WIFI
      "channel"                     => "", #WIFI
      "media"                       => "",
      "ip"                          => "",
      "gateway"                     => "",
      "dns1"                        => "",
      "dns2"                        => "",
      "subnet"                      => "",
      "logical_number"              => "",
      "network_configured"          => "",
      "environment"                 => "",
      "notification_timeout"        => "",
      "notification_interval"       => "",
      "notification_stream_timeout" => "",
      "company_name"                => ""
    }

    def self.setup
      @file = FileDb.new(FILE_PATH, DEFAULT)
      self.host = HOST_STAGING if self.staging?
      @file
    end

    def self.production?
      self.environment == "production"
    end

    def self.staging?
      self.environment == "staging"
    end

    def self.to_production!
      self.host = HOST_PRODUCTION
    end

    def self.to_staging!
      self.host = HOST_STAGING
    end

    def self.method_missing(method, *args, &block)
      setup unless @file
      param = method.to_s
      if @file[param]
        @file[param]
      elsif (param[-1..-1] == "=" && @file[param[0..-2]])
        @file[param[0..-2]] = args.first
      else
        super
      end
    end
  end
end

