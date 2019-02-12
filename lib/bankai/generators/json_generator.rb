# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class JsonGenerator < Base
      def add_oj
        gem 'oj'
        Bundler.with_clean_env { run 'bundle install' }
      end
    end
  end
end
