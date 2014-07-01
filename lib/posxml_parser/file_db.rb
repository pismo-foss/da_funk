module PosxmlParser
  module FileDb
    def posxml_read_db(file_name, key)
      posxml_read_memory_parameter(file_name, key) || posxml_read_key_value(file_name, key)
    end

    def posxml_write_db(file_name, key, value)
      posxml_write_memory_paramter(file_name, key, value)
      posxml_write_key_value(file_name, key, value)
    end

    def posxml_read_db_config(key)
      posxml_read_db(PosxmlParser::Parameters::CONFIG_FILE, key)
    end

    def posxml_write_db_config(key, value)
      posxml_write_db(PosxmlParser::Parameters::CONFIG_FILE, key, value)
    end

    private

    def posxml_read_key_value(file_name, key)
      file_path = posxml_file_path(file_name)
      if File.exist?(file_path)
        file = File.open(file_path, "r")
        file.read.each_line do |line|
          line_key, line_value = line.split("=")[0], line.split("=")[1].chomp
          return line_value if line_key == key
        end
        file.close
      end
      ""
    end

    def posxml_write_key_value(file_name, key, value)
      file_path = posxml_file_path(file_name)
      file_tmp  = posxml_file_path(file_tmp_name(file_name))

      file_content = {}
      if File.exist?(file_path)
        file = File.open(file_path, "r")
        #Serialize
        file.read.each_line do |line|
          file_content[line.split("=")[0]] = line.split("=")[1].chomp
        end
        file.close

        #Define value
        file_content["#{key}"] = value

        #Deserialize
        file = File.open(file_tmp, "w+")
        file_content.each do |line_key, line_value|
          file.write("#{line_key}=#{line_value}\n")
        end

        #Close and write
        file.close

        #Rename
        File.rename(file_tmp, file_path)
      else
        file = File.new(file_path, "w+")
        file.write("#{key}=#{value}\n")
        file.close
      end
    end

    def file_tmp_name(original)
      "#{rand(9999)}_tmp_#{original}"
    end
  end
end
