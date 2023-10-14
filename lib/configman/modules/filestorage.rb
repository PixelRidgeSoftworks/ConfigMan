# frozen_string_literal: true

module ConfigMan
  module Modules
    module FileStorage
      def self.populate_defaults
        {
          'storage_type' => 'local',
          'cloud_provider' => 'none',
          'local_path' => '/path/to/storage'
        }
      end
    end
  end
end
