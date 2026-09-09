# frozen_string_literal: true

module Bankai
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
        next content unless path

        # Replace the whole line: a path source and a version requirement
        # cannot both be given.
        content.sub(/^(\s*)gem 'bankai'.*$/) do
          %(#{Regexp.last_match(1)}gem 'bankai', path: "#{path}")
        end
      end
    end

    def configure_dev_hosts
      application(nil, env: 'development') do
        "config.hosts << '.test'"
      end
    end

    # Falcon replaces Puma as the app server.
    def remove_puma_config
      remove_file('config/puma.rb')
      create_file('bin/dev', <<~SH, force: true)
        #!/usr/bin/env sh
        exec bundle exec falcon serve --bind http://localhost:3000 --count 1 "$@"
      SH
      chmod('bin/dev', 0o755)
    end

    def configure_quiet_assets
      return if options[:api]
      return if options[:skip_asset_pipeline]

      application do
        'config.assets.quiet = true'
      end
    end

    def configure_generators
      application do
        <<-RUBY
    config.generators do |generate|
      generate.helper false
    end
        RUBY
      end
    end

    def setup_default_directories
      [
        'test/factories',
        'test/requests',
        'test/support/matchers',
        'test/support/mixins'
      ].each do |dir|
        empty_directory_with_keep_file dir
      end
    end

    def clear_seed_file
      File.write("#{destination_root}/db/seeds.rb", '')
    end

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
