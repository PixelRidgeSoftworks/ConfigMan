# frozen_string_literal: true

require 'json'

module ConfigMan
  module Parsers
    module JSON
      CONFIG_FILE_PATH = File.join(Dir.pwd, '.config').freeze

      # Parse the .config file and return a hash of the configuration values
      def self.parse(file_path)
        raise ArgumentError, "File not found: #{file_path}" unless File.exist?(file_path)

        @file_path = file_path

        file_content = File.read(file_path)
        parsed_config = ::JSON.parse(file_content)

        raise ArgumentError, "Invalid JSON format in #{file_path}" unless parsed_config.is_a?(Hash)

        parsed_config
      end

      def self.update(key, new_value)
        # Read existing config
        existing_config = parse

        # Update the value
        existing_config[key] = new_value

        # Write the updated config back to the file
        File.open(CONFIG_FILE_PATH, 'w') do |file|
          file.write(::JSON.pretty_generate(existing_config))
        end
      end

      def self.write(config_hash)
        File.open(CONFIG_FILE_PATH, 'w') do |file|
          file.write(::JSON.pretty_generate(config_hash))
        end
      end
    end
  end
end
