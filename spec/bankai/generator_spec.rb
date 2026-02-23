# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'

RSpec.describe Bankai::Generator, :slow do
  before(:all) do
    @tmpdir = Dir.mktmpdir('bankai_test_')
    @project_path = File.join(@tmpdir, 'testapp')

    gem_root = File.expand_path('../..', __dir__)
    bankai_bin = File.join(gem_root, 'exe', 'bankai')

    Bundler.with_unbundled_env do
      success = system(
        'ruby', bankai_bin, 'testapp',
        '--database=sqlite3',
        '--skip-rspec',
        "--path=#{gem_root}",
        chdir: @tmpdir
      )
      raise "Generator failed (exit #{$?.exitstatus})" unless success
    end
  end

  after(:all) do
    FileUtils.remove_entry(@tmpdir) if @tmpdir
  end

  def project_file(*path)
    File.join(@project_path, *path)
  end

  def read_project_file(*path)
    File.read(project_file(*path))
  end

  describe 'Gemfile' do
    subject(:gemfile) { read_project_file('Gemfile') }

    it 'includes rails' do
      expect(gemfile).to match(/gem ['"]rails['"]/)
    end

    it 'includes database adapter' do
      expect(gemfile).to match(/gem ['"]sqlite3['"]/)
    end

    it 'includes bankai' do
      expect(gemfile).to match(/gem ['"]bankai['"]/)
    end
  end

  describe 'static files' do
    it 'generates README.md' do
      expect(File).to exist(project_file('README.md'))
    end

    it 'generates .gitignore' do
      expect(File).to exist(project_file('.gitignore'))
    end

    it 'generates .env.example' do
      expect(File).to exist(project_file('.env.example'))
    end

    it 'generates .ctags' do
      expect(File).to exist(project_file('.ctags'))
    end

    it 'generates .gitlab-ci.yml' do
      expect(File).to exist(project_file('.gitlab-ci.yml'))
    end

    it 'generates .overcommit.yml' do
      expect(File).to exist(project_file('.overcommit.yml'))
    end

    it 'generates rack_mini_profiler initializer' do
      expect(File).to exist(project_file('config', 'initializers', 'rack_mini_profiler.rb'))
    end

    it 'generates oj initializer' do
      expect(File).to exist(project_file('config', 'initializers', 'oj.rb'))
    end
  end

  describe 'configuration injection' do
    it 'configures generators with rspec in application.rb' do
      content = read_project_file('config', 'application.rb')
      expect(content).to include('test_framework :rspec')
    end

    it 'configures quiet assets in application.rb' do
      content = read_project_file('config', 'application.rb')
      expect(content).to include('config.assets.quiet = true')
    end

    it 'configures puma-dev host in development.rb' do
      content = read_project_file('config', 'environments', 'development.rb')
      expect(content).to include('.test')
    end

    it 'configures Bullet in development.rb' do
      content = read_project_file('config', 'environments', 'development.rb')
      expect(content).to include('Bullet.enable')
    end

    it 'configures letter_opener in development.rb' do
      content = read_project_file('config', 'environments', 'development.rb')
      expect(content).to include('letter_opener')
    end

    it 'clears db/seeds.rb' do
      expect(read_project_file('db', 'seeds.rb')).to be_empty
    end
  end

  describe 'directory structure' do
    %w[
      spec/lib/.keep
      spec/controllers/.keep
      spec/helpers/.keep
      spec/support/matchers/.keep
    ].each do |path|
      it "creates #{path}" do
        expect(File).to exist(project_file(path))
      end
    end
  end
end
