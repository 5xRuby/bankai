# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class WheneverGenerator < Base
      def add_whenever
        gem 'whenever', require: false
        Bundler.with_clean_env { run 'rubocop Gemfile -a' }
        Bundler.with_clean_env { run 'bundle install' }
      end

      def initialize_whenever
        Bundler.with_clean_env { run 'wheneverize' }
      end

      def initialize_capistrano
        append_to_file 'Capfile', 'require "whenever/capistrano"' if capistrano?
      end
    end
  end
end
