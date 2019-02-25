# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class CiGenerator < Base
      def configure_ci
        template 'gitlab-ci.yml.erb', '.gitlab-ci.yml'
      end
    end
  end
end
