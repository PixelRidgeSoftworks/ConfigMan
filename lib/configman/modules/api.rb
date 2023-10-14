# frozen_string_literal: true

module ConfigMan
  module Modules
    module Api
      def self.populate_defaults
        {
          'api_endpoint' => 'https://api.example.com',
          'api_key' => 'your_api_key_here',
          'rate_limit' => 1000
        }
      end
    end
  end
end
