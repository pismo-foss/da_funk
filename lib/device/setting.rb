
class Device
  class Setting
    FILE_NAME = "config.dat"
    DEFAULT     = {
      "host"                   => "switch-staging.cloudwalk.io",
      "host_port"              => "31415",
      "ssl"                    => "",
      "user"                   => "",
      "pass"                   => "",
      "apn"                    => "",
      "media"                  => "",
      "ip"                     => "",
      "gateway"                => "",
      "dns1"                   => "",
      "dns2"                   => "",
      "subnet"                 => "",
      "logical_number"         => "",
      "company_name"           => ""
    }

    def self.setup
      @file = FileDb.new(FILE_NAME, DEFAULT)
    end

    def self.method_missing(method, *args, &block)
      param = method.to_s
      if @file[param]
        @file[params]
      elsif (param[-1..1] == "=" && @file[param[0..-2]])
        @file[param[0..-2]] = args.first
      else
        super
      end
    end
  end
end

