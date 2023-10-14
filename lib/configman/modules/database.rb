# frozen_string_literal: true

module ConfigMan
  module Modules
    module Database
      def self.populate_defaults
        {
          'db_host' => 'localhost',
          'db_port' => 3306,
          'db_user' => 'root',
          'db_password' => 'password',
          'db_name' => 'my_database'
        }
      end
    end
  end
end
