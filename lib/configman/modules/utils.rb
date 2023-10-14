# frozen_string_literal: true

# config_util.rb

module ConfigMan
  module Utils
    def self.sort_into_sections(config_hash, expected_keys, loaded_modules)
      sorted_config = Hash.new { |hash, key| hash[key] = {} }

      config_hash.each do |key, value|
        section_found = false

        expected_keys.each do |section, keys|
          next unless loaded_modules.include?(section)

          next unless keys.include?(key)

          sorted_config[section][key] = value
          section_found = true
          break
        end

        sorted_config['General'][key] = value unless section_found
      end

      sorted_config
    end
  end
end
