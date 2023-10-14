# frozen_string_literal: true

module ConfigMan
  module Modules
    module Logging
      def self.populate_defaults
        {
          'log_level' => 'info',
          'log_file' => 'application.log',
          'log_rotation' => 'daily'
        }
      end
    end
  end
end
