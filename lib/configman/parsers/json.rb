# frozen_string_literal: true

require 'json'
require_relative '../modules/utils'

module ConfigMan
  module Parsers
    module JSON
      CONFIG_FILE_PATH = File.join(Dir.pwd, '.config').freeze

      # Parse the .config file and return a hash of the configuration values
      def self.parse(file_path)
        raise ArgumentError, "File not found: #{file_path}" unless File.exist?(file_path)

        file_content = File.read(file_path)
        parsed_config = ::JSON.parse(file_content)

        raise ArgumentError, "Invalid JSON format in #{file_path}" unless parsed_config.is_a?(Hash)

        parsed_config
      end

      def self.update(key, new_value)
        existing_config = parse(CONFIG_FILE_PATH)
        existing_config[key] = new_value

        File.open(CONFIG_FILE_PATH, 'w') do |file|
          file.write(::JSON.pretty_generate(existing_config))
        end
      end

      def self.write(config_hash)
        # Access the loaded modules and expected keys from the main class
        loaded_modules = ConfigMan.used_modules
        expected_keys = ConfigMan.expected_keys

        # Use the utility method to sort the keys into their respective sections
        sorted_config = Utils.sort_into_sections(config_hash, expected_keys, loaded_modules)

        File.open(CONFIG_FILE_PATH, 'w') do |file|
          file.write(::JSON.pretty_generate(sorted_config))
        end
      end
    end
  end
end
