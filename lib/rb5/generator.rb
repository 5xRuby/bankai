# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Rb5
  # :nodoc:
  class Generator < Rails::Generators::AppGenerator
    hide!

    class_option :database, type: :string, aliases: '-d', default: 'postgresql',
                            desc: 'Configure for selected database ' \
                                  "(options: #{DATABASES.join('/')})"

    class_option :skip_test, type: :boolean, default: true,
                             desc: 'Skip test files'

    class_option :skip_coffee, type: :boolean, default: true,
                               desc: "Don't use CoffeeScript"

    class_option :skip_capistrano, type: :boolean, default: false,
                                   desc: "Don't use Capistrano"

    class_option :skip_rspec, type: :boolean, default: false,
                              desc: 'Skip rspec files'

    def finish_template
      invoke :customization
      super
    end

    def customization
      invoke :setup_development_environment
      invoke :configure_app
      invoke :setup_dotfiles
      invoke :setup_default_directories
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :configure_quiet_assets
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

    def setup_default_directories
      build :setup_default_directories
    end

    def depends_on_system_test?
      !(options[:skip_system_test] || options[:skip_rspec] || options[:api])
    end

    def self.banner
      "rb5 #{arguments.map(&:usage).join(' ')} [options]"
    end

    protected

    # rubocop:disable Naming/AccessorMethodName
    def get_builder_class
      Rb5::Builder
    end
    # rubocop:enable Naming/AccessorMethodName
  end
end
