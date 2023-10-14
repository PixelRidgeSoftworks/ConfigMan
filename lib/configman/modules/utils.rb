# frozen_string_literal: true

# config_util.rb

module ConfigMan
  module Utils
    def self.sort_into_sections(config_hash, expected_keys, loaded_modules)
      # Convert loaded_modules to uppercase for comparison
      loaded_modules_upcase = loaded_modules.map(&:upcase)

      sorted_config = Hash.new { |hash, key| hash[key] = {} }

      config_hash.each do |key, value|
        section_found = false

        expected_keys.each do |section, keys|
          # Skip the section if it's not in the loaded modules
          next unless loaded_modules_upcase.include?(section.upcase)

          # Skip the key if it's not in the expected keys for this section
          next unless keys.include?(key)

          sorted_config[section][key] = value
          section_found = true
          break
        end

        # If the key doesn't match any of the expected keys, put it in the 'General' section
        sorted_config['General'][key] = value unless section_found
      end

      sorted_config
    end
  end
end
