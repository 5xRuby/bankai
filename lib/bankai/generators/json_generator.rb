# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class JsonGenerator < Base
      def add_oj
        gem 'oj'
        in_root { run 'bundle install' }

        initializer 'oj.rb' do
          "# frozen_string_literal: true\n\n" \
            'Oj.optimize_rails'
        end
      end
    end
  end
end
