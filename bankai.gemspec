# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bankai/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= #{Bankai::RUBY_VERSION}"
  spec.name          = 'bankai'
  spec.version       = Bankai::VERSION
  spec.authors       = %w[5xRuby 蒼時弦也]
  spec.email         = ['hi@5xruby.tw', 'contact0@frost.tw']

  spec.summary       = 'The Rails template for 5xRuby'
  spec.description   = 'The tool to generate Rails template for 5xRuby'
  spec.homepage      = 'https://github.com/5xRuby/bankai'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the
  # RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.2.26'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~> 1.8.1'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'

  # TODO: Allow specify rails version
  spec.add_dependency 'rails', ">= #{Bankai::RAILS_VERSION}"
end
