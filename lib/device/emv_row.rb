class Device
  class EMVRow
    EMV_SCHEME = [
      [:length                                           , 3],
      [:identification                                   , 1],
      [:acquirer_id                                      , 2],
      [:index                                            , 2],
      [:aid_length                                       , 2],
      [:aid                                              , 32],
      [:application_type                                 , 2],
      [:label                                            , 16],
      [:table_type                                       , 2],
      [:application_version_number_1                     , 4],
      [:application_version_number_2                     , 4],
      [:application_version_number_3                     , 4],
      [:terminal_country_code                            , 3],
      [:transaction_currency_code                        , 3],
      [:transaction_currency_exponent                    , 1],
      [:merchant_identifier                              , 15],
      [:merchant_category_code                           , 4],
      [:terminal_identification                          , 8],
      [:terminal_capabilities                            , 6],
      [:terminal_additional_capabilities                 , 10],
      [:terminal_type                                    , 2],
      [:terminal_action_code_default                     , 10],
      [:terminal_action_code_denial                      , 10],
      [:terminal_action_code_online                      , 10],
      [:terminal_floor_limit                             , 8],
      [:reserved                                         , 32],
      [:tdol                                             , 40],
      [:ddol                                             , 40],
      [:authorization_code_offline_approved              , 2],
      [:authorization_code_offline_declined              , 2],
      [:authorization_code_unable_online_offline_approved, 2],
      [:authorization_code_unable_online_offline_declined, 2]
    ]

    PKI_SCHEME = [
      [:length                                           , 3],
      [:identification                                   , 1],
      [:acquirer_id                                      , 2],
      [:index                                            , 2],
      [:rid                                              , 10],
      [:ca_public_key_index                              , 2],
      [:reserved                                         , 2],
      [:ca_public_key_exponent_byte_length               , 1],
      [:ca_public_key_exponent                           , 6],
      [:ca_public_key_modulus_byte_length                , 3],
      [:ca_public_key_modulus                            , 496],
      [:status_check_sum                                 , 1],
      [:ca_public_key_check_sum                          , 48],
      [:master_key_index                                 , 2],
      [:working_key                                      , 32]
    ]

    attr_accessor :hash, :type

    def initialize(string)
      @string = string
      parse(string)
    end

    def emv?
      self.type == :emv
    end

    def pki?
      self.type == :pki
    end

    def method_missing(method, *args, &block)
      param = method.to_s
      if @hash[method]
        @hash[method]
      elsif (param[-1..-1] == "=" && @hash[param[0..-2]])
        @hash[param[0..-2]] = args.first
      else
        super
      end
    end

    private
    def parse(string)
      @type, scheme = check_type(string)

      index = 0
      @hash = Hash.new
      scheme.each do |key,value|
        @hash[key] = string[index..(index + value - 1)]
        index += value
      end
    end

    def check_type(string)
      case string[3]
      when "1"
        [:emv, EMV_SCHEME]
      when "2"
        [:pki, PKI_SCHEME]
      when "3"
      when "4"
      when "5"
      else
        [:emv, EMV_SCHEME]
      end
    end
  end
end

