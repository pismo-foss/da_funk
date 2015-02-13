class Device
  class Runtime
    def self.adapter
      Device.adapter::Runtime
    end

    # Execute app in new context.
    #   To execute the should exists a zip file cotain the app,
    #   previously downloaded from CloudWalk.
    #
    # @param app [String] App name, example "app", should exists file app.zip
    # @param json [String] Parameters to confifure new aplication.
    # @return [Object] From the new runtime instance.
    def self.execute(app, json)
      zip = "./#{app}.zip"
      Device::Display.clear
      raise Errno::ENOENT, zip unless File.exists?(zip)
      raise "Problem to unzip #{zip}" unless Miniz.unzip(zip)
      return mrb_eval "Context.start('#{app}', '#{Device.adapter}', '#{buf}')"
    end
  end
end
