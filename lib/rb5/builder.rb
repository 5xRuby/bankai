# frozen_string_literal: true

module Rb5
  # :nodoc:
  class Builder < Rails::AppBuilder
    def gemfile
      template 'Gemfile.erb', 'Gemfile'
    end
  end
end
