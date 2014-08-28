# TODO@akolomiychuk: Allow specifying GET queries in config instead of hashes.
# TODO@akolomiychuk: Handling interrupt.
require 'yaml'

class OdeskJobnotifier
  class CommandLineTool
    def initialize(config_dir = Dir.home)
      file_path = "#{config_dir}/.odesk-jobnotifier.yml"
      if File.exists?(file_path)
        @config = convert_params(YAML.load_file(file_path))
      else
        abort("Configuration file #{file_path} is missing.")
      end
    end

    def run
      OdeskJobnotifier.new(@config).run
    end

    private

    def convert_params(params)
      params.inject({}) do |memo, (k, v)|
        memo[k.to_sym] =
          if v.instance_of?(Hash)
            convert_params(v)
          elsif v.instance_of?(Array)
            memo[k.to_sym] = v.map do |el|
              el.instance_of?(Hash) ? convert_params(el) : el
            end
          else
            memo[k.to_sym] = v
          end

        memo
      end
    end
  end
end
