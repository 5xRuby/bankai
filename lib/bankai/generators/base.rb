# frozen_string_literal: true

require 'rails/generators'

module Bankai
  module Generators
    # :nodoc:
    class Base < Rails::Generators::Base
      include Bankai::Helper

      def self.default_source_root
        File.expand_path(File.join('..', '..', '..', 'templates'), __dir__)
      end

      private

      def app_name
        if Rails::VERSION::MAJOR >= 6
          Rails.app_class.module_parent_name.demodulize.underscore.dasherize
        else
          Rails.app_class.parent_name.demodulize.underscore.dasherize
        end
      end
    end
  end
end
