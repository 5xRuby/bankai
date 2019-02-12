# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class MailerGenerator < Base
      def configure_letter_opener
        inject_into_file(
          'config/environments/development.rb',
          configuration,
          after: 'config.file_watcher = ' \
          "ActiveSupport::EventedFileUpdateChecker\n"
        )
      end

      private

      def configuration
        <<-RUBY

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
        RUBY
      end
    end
  end
end
