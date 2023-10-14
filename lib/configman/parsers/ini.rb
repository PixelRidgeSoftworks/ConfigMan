# frozen_string_literal: true

require 'inifile'
require_relative '../modules/utils'

module ConfigMan
  module Parsers
    module INI
      CONFIG_FILE_PATH = File.join(Dir.pwd, '.config').freeze

      # Parse the .config file and return a hash of the configuration values
      def self.parse(file_path)
        raise ArgumentError, "File not found: #{file_path}" unless File.exist?(file_path)

        ini = IniFile.load(file_path)
        parsed_config = ini.to_h

        raise ArgumentError, "Invalid INI format in #{file_path}" unless parsed_config.is_a?(Hash)

        parsed_config
      end

      def self.update(key, new_value)
        existing_config = parse(CONFIG_FILE_PATH)
        section, key = key.split('.', 2)
        existing_config[section] ||= {}
        existing_config[section][key] = new_value

        ini = IniFile.new(content: existing_config)
        ini.write(filename: CONFIG_FILE_PATH)
      end

      def self.write(config_hash)
        # Access the loaded modules and expected keys from the main class
        loaded_modules = ConfigMan.used_modules
        expected_keys = ConfigMan.expected_keys

        # Sort the keys into their respective sections
        sorted_config = Utils.sort_into_sections(config_hash, expected_keys, loaded_modules)

        # Debug statement to output the sorted_config
        puts 'Debug: About to write the following sorted_config to INI file:'
        p sorted_config

        # Write the sorted config to the INI file
        ini = IniFile.new(content: sorted_config)
        ini.write(filename: CONFIG_FILE_PATH)
      end
    end
  end
end
