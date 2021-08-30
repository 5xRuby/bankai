# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class CiGenerator < Base
      class_option :api, type: :boolean, default: false

      def configure_ci
        template 'gitlab-ci.yml.erb', '.gitlab-ci.yml'
      end
    end
  end
end
