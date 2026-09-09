# frozen_string_literal: true

require 'bundler'
require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Bankai
  # :nodoc:
  class Generator < Rails::Generators::AppGenerator
    hide!

    class_option :database, type: :string, aliases: '-d', default: 'sqlite3',
                            desc: 'Configure for selected database ' \
                                  "(options: #{Rails::Generators::Database::DATABASES.join('/')})"

    class_option :capistrano, type: :boolean, default: false,
                              desc: 'Use Capistrano'

    class_option :skip_test, type: :boolean, default: false,
                             desc: 'Skip test files'

    class_option :skip_kamal, type: :boolean, default: true,
                              desc: 'Skip Kamal setup'

    class_option :skip_solid, type: :boolean, default: false,
                              desc: 'Skip Solid Queue/Cache/Cable setup'

    class_option :skip_thruster, type: :boolean, default: false,
                                 desc: 'Skip Thruster setup'

    class_option :path, type: :string, default: nil,
                        desc: 'Path to the gem'

    def finish_template
      invoke :customization
      super
    end

    def customization
      invoke :customize_gemfile
      invoke :setup_development_environment
      invoke :configure_app
      invoke :setup_dotfiles
      invoke :install_binstubs
      invoke :generate_default
      invoke :setup_default_directories
    end

    def customize_gemfile
      build :replace_gemfile, options[:path]
      bundle_command 'install'
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :configure_quiet_assets
      build :configure_dev_hosts
      build :remove_puma_config
      build :configure_generators
      build :clear_seed_file
      # TODO: Add setup script
    end

    def configure_app
      say 'Configuring app'
      # TODO: Configure ActionMailer
      build :setup_rack_mini_profiler
    end

    def setup_dotfiles
      build :copy_dotfiles
    end

    def install_binstubs
      run('bundle binstubs bundler')
    end

    def generate_default
      Bundler.with_original_env do
        generate('bankai:testing') unless options[:skip_test]
        generate('bankai:ci', options.api? ? '--api' : '')
        generate('bankai:json')
        generate('bankai:db_optimizations')
        generate('bankai:mailer')
        generate('bankai:deploy') if options[:capistrano]
        generate('annotate_rb:install')
        generate('bankai:lint')
      end
    end

    def setup_default_directories
      build :setup_default_directories
    end

    def depends_on_system_test?
      !(options[:skip_system_test] || options[:skip_test] || options[:api])
    end

    def self.banner
      "bankai #{arguments.map(&:usage).join(' ')} [options]"
    end

    protected

    def rails_command(command, command_options = {})
      Bundler.with_original_env { super }
    end

    # rubocop:disable Naming/AccessorMethodName
    def get_builder_class
      Bankai::Builder
    end
    # rubocop:enable Naming/AccessorMethodName
  end
end
