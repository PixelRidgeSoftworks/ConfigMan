# frozen_string_literal: true

require 'yaml'

module ConfigMan
  module Parsers
    module YAML
      CONFIG_FILE_PATH = File.join(Dir.pwd, '.config').freeze

      # Parse the .config file and return a hash of the configuration values
      def self.parse(file_path)
        raise ArgumentError, "File not found: #{file_path}" unless File.exist?(file_path)

        parsed_config = ::YAML.load_file(file_path)

        raise ArgumentError, "Invalid YAML format in #{file_path}" unless parsed_config.is_a?(Hash)

        parsed_config
      end

      def self.update(key, new_value)
        existing_config = parse(CONFIG_FILE_PATH)
        existing_config[key] = new_value

        File.open(CONFIG_FILE_PATH, 'w') do |file|
          file.write(existing_config.to_yaml)
        end
      end

      def self.write(config_hash)
        File.open(CONFIG_FILE_PATH, 'w') do |file|
          file.write(config_hash.to_yaml)
        end
      end
    end
  end
end
