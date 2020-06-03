# frozen_string_literal: true

if ENV.fetch('COVERAGE', false) || ENV.fetch('CI', false)
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter 'vendor'
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
