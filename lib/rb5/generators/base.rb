# frozen_string_literal: true

require 'rails/generators'

module Rb5
  module Generators
    # :nodoc:
    class Base < Rails::Generators::Base
      def self.default_source_root
        File.expand_path(File.join('..', '..', '..', 'templates'), __dir__)
      end

      private

      def app_name
        Rails.app_class.parent_name.demodulize.underscore.dasherize
      end
    end
  end
end
