# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class WheneverGenerator < Base
      def add_whenever
        gem 'whenever', require: false
        Bundler.with_clean_env { run 'rubocop -a Gemfile' }
        Bundler.with_clean_env { run 'bundle install' }
      end

      def initialize_whenever
        Bundler.with_clean_env { run "wheneverize #{destination_root}" }
      end

      def initialize_capistrano
        return unless capistrano?

        inject_into_file(
          'Capfile',
          "require 'whenerver/capistrano'\n",
          after: "# require \"capistrano/passenger\"\n"
        )
      end
    end
  end
end
