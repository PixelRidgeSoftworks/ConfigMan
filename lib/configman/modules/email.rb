# frozen_string_literal: true

module ConfigMan
  module Modules
    module Email
      def self.populate_defaults
        {
          'smtp_server' => 'smtp.example.com',
          'smtp_port' => 587,
          'smtp_user' => 'user@example.com',
          'smtp_password' => 'password_here',
          'smtp_protocol' => 'SSL/TLS'
        }
      end
    end
  end
end
