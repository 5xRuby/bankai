# frozen_string_literal: true

require_relative 'base'

module Rb5
  module Generators
    # :nodoc:
    class DeployGenerator < Base
      def install_capistrano
        Bundler.with_clean_env { run 'bundle exec cap install' }
      end

      def configure_capfile
        inject_into_file(
          'Capfile',
          capistrano_plugins,
          after: "# require \"capistrano/passenger\"\n"
        )
      end

      def replace_deploy_config
        template 'deploy.rb.erb', 'config/deploy.rb', force: true
      end

      protected

      def repo_url
        res = `git remote get-url origin`
        return 'git@example.com:me/my_repo.git' if res.blank?

        res
      end

      private

      def capistrano_plugins
        <<-RUBY
  require "capistrano/bundler"
  require "capistrano/rails/assets"
  require "capistrano/rails/migrations"
        RUBY
      end
    end
  end
end
