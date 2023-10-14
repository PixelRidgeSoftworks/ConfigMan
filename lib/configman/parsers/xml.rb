# frozen_string_literal: true

require 'rexml/document'

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

        File.open(CONFIG_FILE_PATH, 'w') { |file| doc.write(file) }
      end

      def self.write(config_hash)
        doc = REXML::Document.new
        doc.add_element('config')
        config_hash.each { |k, v| doc.root.add_element(k).text = v }

        File.open(CONFIG_FILE_PATH, 'w') { |file| doc.write(file) }
      end
    end
  end
end
