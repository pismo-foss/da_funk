
class Device
  class Setting
    FILE_NAME = "config.dat"
    DEFAULT     = {
      "host"           => "switch-staging.cloudwalk.io",
      "host_port"      => "31416",
      "ssl"            => "1",
      "user"           => "",
      "password"       => "", #WIFI
      "apn"            => "",
      "authentication" => "", #WIFI
      "essid"          => "", #WIFI
      "bssid"          => "", #WIFI
      "cipher"         => "", #WIFI
      "mode"           => "", #WIFI
      "channel"        => "", #WIFI
      "media"          => "",
      "ip"             => "",
      "gateway"        => "",
      "dns1"           => "",
      "dns2"           => "",
      "subnet"         => "",
      "logical_number" => "",
      "company_name"   => ""
    }

    def self.setup
      @file = FileDb.new(FILE_NAME, DEFAULT)
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

