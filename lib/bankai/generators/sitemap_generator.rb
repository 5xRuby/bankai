# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    HOST_TEMPLATE = <<-RUBY.freeze

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
        Bundler.with_clean_env { run 'bundle install' }
      end

      def init_sitemap
        Bundler.with_clean_env { run 'bundle exec rake sitemap:install' }
      end

      def generate_sitmap_config
        gsub_file 'config/sitemap.rb',
                  %r{"http:\/\/www.example.com"},
                  HOST_TEMPLATE
        Bundler.with_clean_env do
          run 'bundle exec rubocop -a config/sitemap.rb'
        end
      end
    end
  end
end
