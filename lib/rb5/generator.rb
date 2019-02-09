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

    def self.banner
      "rb5 #{arguments.map(&:usage).join(' ')} [options]"
    end
  end
end
