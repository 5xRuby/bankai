# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class WheneverGenerator < Base
      def add_whenever
        gem 'whenever', require: false
        execute_command :bundle, 'exec rubocop -a Gemfile'
        execute_command :bundle, 'install'
      end

      def initialize_whenever
        execute_command :bundle, "exec wheneverize #{destination_root}"
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
