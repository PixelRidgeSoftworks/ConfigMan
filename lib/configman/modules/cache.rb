# frozen_string_literal: true

module ConfigMan
  module Modules
    module Cache
      def self.populate_defaults
        {
          'cache_type' => 'Redis',
          'host' => 'localhost',
          'port' => 6379
        }
      end
    end
  end
end
