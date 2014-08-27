require 'yaml'

class OdeskJobnotifier
  class CommandLineTool
    def initialize(config_dir = Dir.home)
      @config = YAML.load_file("#{config_dir}/.odesk-jobnotifier.yml")
    end

    def run
      OdeskJobnotifier.new(@config).run
    end
  end
end
