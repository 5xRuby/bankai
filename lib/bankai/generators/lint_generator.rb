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
        template 'rubocop.yml.erb', '.rubocop.yml'
      end

      def install_overcommit
        Bundler.with_clean_env { run 'bundle exec overcommit --install' }
      end

      def rubocop_autocorrect
        Bundler.with_clean_env { run 'bundle exec rubocop --auto-correct' }
      end

      def rubocop_todo
        Bundler.with_clean_env { run 'bundle exec rubocop --auto-gen-config' }
      end
    end
  end
end
