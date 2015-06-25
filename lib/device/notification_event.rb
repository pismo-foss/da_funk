class Device
  class NotificationEvent
    attr_reader :values, :coalesce, :ltime, :payload, :name, :event, :message, :value, :body, :callback, :parameters

    def initialize(values)
      @values = values
      parse(values)
    end

    def type
      @event
    end

    private
    def parse(values)
      @coalesce = values["Coalesce"]
      @ltime    = values["LTime"]
      @payload  = values["Payload"]
      @name     = values["Name"]
      @event    = values["Event"]

      @message  = payload.to_s.gsub("=>", " : ")
      @value    = JSON.parse(@message) unless @message.empty?
      @body     = extract_body(value)

      @callback, *@parameters = @body.to_s.split("|")
    end

    def extract_body(value)
      unless value.nil?
        return value["Body"] if value["Body"]
        # TODO: For some reason the JSON parse has a problem
        # and extract "B" from "Body"
        return value["ody"] if value["ody"]
      end
    end
  end
end

