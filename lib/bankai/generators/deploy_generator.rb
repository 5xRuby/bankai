# frozen_string_literal: true

require_relative 'base'

module Bankai
  module Generators
    # :nodoc:
    class DeployGenerator < Base
      DEFAULT_REPO = 'git@example.com:me/my_repo.git'

      def install_capistrano
        execute_command :bundle, 'exec cap install'
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
        return DEFAULT_REPO unless Dir.exist?('.git')

        res = `git remote get-url origin`
        return DEFAULT_REPO if res.blank?

        res
      end

      private

      def capistrano_plugins
        plugins = []
        plugins << 'require "capistrano/bundler"'
        plugins << 'require "capistrano/rails/assets"' unless options[:api]
        plugins << 'require "capistrano/rails/migrations"'
        plugins.join("\n")
      end
    end
  end
end
