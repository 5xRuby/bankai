# frozen_string_literal: true

return unless ENV.fetch('COVERAGE', false) || ENV.fetch('CI', false)

require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter if ENV.fetch('GITLAB_CI', false)
SimpleCov.refuse_coverage_drop

SimpleCov.start 'rails' do
  skip 'vendor'
end
