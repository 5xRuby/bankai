# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class WheneverGenerator < Base
      def add_whenever
        gem 'whenever', require: false
        in_root { run 'rubocop -a Gemfile' }
        in_root { run 'bundle install' }
      end

      def initialize_whenever
        in_root { run "wheneverize #{destination_root}" }
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
