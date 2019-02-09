# frozen_string_literal: true

require_relative 'base'

module Rb5
  module Generators
    # :nodoc:
    class CiGenerator < Base
      def configure_ci
        template 'gitlab-ci.yml.erb', '.gitlab-ci.yml'
      end

      protected

      def pg?
        gemfile.match?(/gem .pg./)
      end

      def mysql?
        gemfile.match?(/gem .mysql2./)
      end

      private

      def gemfile
        @gemfile ||= File.read(destination_root + '/Gemfile')
      end
    end
  end
end
