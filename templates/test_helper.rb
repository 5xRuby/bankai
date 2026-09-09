# frozen_string_literal: true

# Must be loaded before the application, so SimpleCov sees every file.
require_relative 'support/coverage'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails is running in production mode!') if Rails.env.production?

require 'rails/test_help'
require 'shoulda-context'
require 'shoulda/matchers'
require 'faker'

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }

module ActiveSupport
  # :nodoc:
  class TestCase
    include FactoryBot::Syntax::Methods

    # Test data comes from factories, so there are no fixtures to preserve and
    # DatabaseRewinder does the cleaning instead of a wrapping transaction.
    self.use_transactional_tests = false
  end
end
