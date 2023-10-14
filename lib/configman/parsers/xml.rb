# frozen_string_literal: true

require 'rexml/document'
require 'rexml/formatters/pretty'
require_relative '../modules/utils'

module ConfigMan
  module Parsers
    module XML
      CONFIG_FILE_PATH = File.join(Dir.pwd, '.config').freeze

      # Parse the .config file and return a hash of the configuration values
      def self.parse(file_path)
        raise ArgumentError, "File not found: #{file_path}" unless File.exist?(file_path)

        xml_file = File.new(file_path)
        document = REXML::Document.new(xml_file)
        parsed_config = {}

        document.elements.each('config/*') do |element|
          parsed_config[element.name] = element.text
        end

        raise ArgumentError, "Invalid XML format in #{file_path}" unless parsed_config.is_a?(Hash)

        parsed_config
      end

      def self.update(key, new_value)
        existing_config = parse(CONFIG_FILE_PATH)
        existing_config[key] = new_value

        doc = REXML::Document.new
        doc.add_element('config')
        existing_config.each { |k, v| doc.root.add_element(k).text = v }

        formatter = REXML::Formatters::Pretty.new
        File.open(CONFIG_FILE_PATH, 'w') do |file|
          formatter.write(doc, file)
        end
      end

      def self.write(config_hash)
        # Access the loaded modules and expected keys from the main class
        loaded_modules = ConfigMan.used_modules
        expected_keys = ConfigMan.expected_keys

        # Sort the keys into their respective sections
        sorted_config = Utils.sort_into_sections(config_hash, expected_keys, loaded_modules)

        doc = REXML::Document.new
        doc.add_element('config')

        sorted_config.each do |section, section_data|
          section_element = doc.root.add_element(section)
          section_data.each { |k, v| section_element.add_element(k).text = v }
        end

        formatter = REXML::Formatters::Pretty.new
        File.open(CONFIG_FILE_PATH, 'w') do |file|
          formatter.write(doc, file)
        end
      end
    end
  end
end
