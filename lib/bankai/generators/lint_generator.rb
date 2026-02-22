# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class LintGenerator < Base
      def configure_overcommit
        template 'overcommit.yml.erb', '.overcommit.yml'
      end

      def configure_rubocop
        return if Rails::VERSION::MAJOR >= 8

        template 'rubocop.yml.erb', '.rubocop.yml'
      end

      def install_overcommit
        run 'bundle exec overcommit --install'
      end

      def rubocop_autocorrect
        return if Rails::VERSION::MAJOR >= 8

        run 'bundle exec rubocop --auto-correct-all'
      end

      def rubocop_todo
        return if Rails::VERSION::MAJOR >= 8

        run 'bundle exec rubocop --auto-gen-config'
      end
    end
  end
end
