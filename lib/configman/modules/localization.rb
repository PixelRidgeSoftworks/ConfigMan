# frozen_string_literal: true

module ConfigMan
  module Modules
    module Localization
      def self.populate_defaults
        {
          'language' => 'en',
          'time_zone' => 'UTC'
        }
      end
    end
  end
end
