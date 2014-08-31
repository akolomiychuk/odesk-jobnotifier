require 'yaml'

class OdeskJobnotifier
  # Handles invoking gem with binary.
  class CommandLineTool
    def initialize(config_dir = Dir.home)
      file_path = "#{config_dir}/.odesk-jobnotifier.yml"
      if File.exist?(file_path)
        config = YAML.load_file(file_path)
        config['queries'] = convert_query_string_params(config['queries'])
        @config = convert_params(config)
      else
        abort("Configuration file #{file_path} is missing.")
      end
    end

    def run
      OdeskJobnotifier.new(@config).run
    end

    private

    def convert_query_string_params(queries)
      queries.map do |q|
        if q.instance_of?(String)
          CGI.parse(URI(q).query).each_with_object({}) do |(k, v), memo|
            memo[k] = v.first
          end
        else
          q
        end
      end
    end

    def convert_params(params)
      params.each_with_object({}) do |(k, v), memo|
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
      end
    end
  end
end
