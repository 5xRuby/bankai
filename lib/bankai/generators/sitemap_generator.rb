# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    HOST_TEMPLATE = <<-RUBY

      if Rails.env.production?
        "https://\#{ENV['APPLICATION_HOST']}"
      else
        "http://\#{ENV['APPLICATION_HOST']}"
      end
    RUBY

    # :nodoc:
    class SitemapGenerator < Base
      def add_sitemap_generator
        gem 'sitemap_generator'
        in_root { run 'bundle install' }
      end

      def init_sitemap
        in_root { run 'bundle exec rake sitemap:install' }
      end

      def generate_sitmap_config
        gsub_file 'config/sitemap.rb',
                  %r{"http://www.example.com"},
                  HOST_TEMPLATE
        in_root do
          run 'bundle exec rubocop -a config/sitemap.rb'
        end
      end
    end
  end
end
