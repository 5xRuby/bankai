# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class DbOptimizationsGenerator < Base
      def configure_bullet
        inject_into_file(
          'config/environments/development.rb',
          configuration,
          after: '# config.action_cable.disable_request_forgery_protection = true'
        )
      end

      private

      def configuration
        <<-RUBY

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end
        RUBY
      end
    end
  end
end
