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
  end
end
