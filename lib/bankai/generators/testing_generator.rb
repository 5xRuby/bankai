# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class TestingGenerator < Base
      def generate_rspec
        generate 'rspec:install'
      end

      def configure_rspec
        remove_file 'spec/rails_helper.rb'
        remove_file 'spec/spec_helper.rb'
        copy_file 'rails_helper.rb', 'spec/rails_helper.rb'
        copy_file 'spec_helper.rb', 'spec/spec_helper.rb'
      end

      def provide_shoulda_matchers_config
        copy_file(
          'spec/shoulda_matchers.rb',
          'spec/support/shoulda_matchers.rb'
        )
      end

      def provide_database_rewinder_config
        copy_file(
          'spec/database_rewinder.rb',
          'spec/support/database_rewinder.rb'
        )
      end
    end
  end
end
