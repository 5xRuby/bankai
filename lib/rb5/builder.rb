# frozen_string_literal: true

module Rb5
  # :nodoc:
  class Builder < Rails::AppBuilder
    def readme
      template 'README.md.erb', 'README.md'
    end

    def gitignore
      template 'gitignore.erb', '.gitignore'
    end

    def gemfile
      template 'Gemfile.erb', 'Gemfile'
    end

    def replace_gemfile(path)
      template 'Gemfile.erb', 'Gemfile', force: true do |content|
        if path
          content.gsub(/gem .rb5./) { |s| %(#{s}, path: "#{path}") }
        else
          content
        end
      end
    end

    def configure_quiet_assets
      config = <<-RUBY
    config.assets.quiet = true
      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    # rubocop:disable Metrics/MethodLength
    def configure_generators
      config = <<-RUBY
    config.generators do |generate|
      generate.helper false
      generate.javascripts false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def setup_default_directories
      [
        'spec/lib',
        'spec/controllers',
        'spec/helpers',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples'
      ].each do |dir|
        empty_directory_with_keep_file dir
      end
    end
    # rubocop:enable Metrics/MethodLength

    def setup_rack_mini_profiler
      copy_file(
        'rack_mini_profiler.rb',
        'config/initializers/rack_mini_profiler.rb'
      )
    end

    def copy_dotfiles
      directory('dotfiles', '.')
    end
  end
end
