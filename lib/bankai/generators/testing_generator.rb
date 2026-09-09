# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class TestingGenerator < Base
      def configure_minitest
        template 'test_helper.rb', 'test/test_helper.rb', force: true
      end

      def provide_coverage_config
        copy_file 'test/coverage.rb', 'test/support/coverage.rb'
      end

      def provide_shoulda_matchers_config
        copy_file 'test/shoulda_matchers.rb', 'test/support/shoulda_matchers.rb'
      end

      def provide_database_rewinder_config
        copy_file 'test/database_rewinder.rb', 'test/support/database_rewinder.rb'
      end
    end
  end
end
