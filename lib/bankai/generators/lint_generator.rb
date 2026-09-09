# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class LintGenerator < Base
      def configure_overcommit
        template 'overcommit.yml.erb', '.overcommit.yml'
      end

      # Overwrites the .rubocop.yml Rails 8 generates for itself.
      def configure_rubocop
        template 'rubocop.yml.erb', '.rubocop.yml', force: true
      end

      def install_overcommit
        run 'bundle exec overcommit --install'
      end

      def rubocop_autocorrect
        run 'bundle exec rubocop --autocorrect-all'
      end

      def rubocop_todo
        run 'bundle exec rubocop --auto-gen-config'
      end
    end
  end
end
