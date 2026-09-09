# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'
require 'open3'

RSpec.describe Bankai::Generator, :slow do
  before(:all) do
    @tmpdir = Dir.mktmpdir('bankai_test_')
    @project_path = File.join(@tmpdir, 'testapp')

    gem_root = File.expand_path('../..', __dir__)
    bankai_bin = File.join(gem_root, 'exe', 'bankai')

    output, status = Open3.capture2e(
      'ruby', bankai_bin, 'testapp',
      '--database=sqlite3',
      "--path=#{gem_root}",
      chdir: @tmpdir
    )
    unless status.success?
      diag = "Ruby: #{RUBY_VERSION}, Bundler: #{Bundler::VERSION}\n"
      diag += "GEM_HOME: #{ENV['GEM_HOME']}\n"
      diag += "Gem.default_dir: #{Gem.default_dir}\n"
      diag += "BUNDLE_GEMFILE: #{ENV['BUNDLE_GEMFILE']}\n"
      diag += "Gemfile.lock exists: #{File.exist?(File.join(@project_path, 'Gemfile.lock'))}\n"
      diag += ".bundle/config exists: #{File.exist?(File.join(@project_path, '.bundle', 'config'))}\n"
      raise "Generator failed (exit #{status.exitstatus}):\n\n--- Diagnostics ---\n#{diag}\n--- Output (last 80 lines) ---\n#{output.lines.last(80).join}"
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

    it 'uses falcon instead of puma' do
      expect(gemfile).to match(/gem ['"]falcon-rails['"]/)
      expect(gemfile).not_to match(/gem ['"]puma['"]/)
    end

    it 'uses annotaterb instead of annotate' do
      expect(gemfile).to match(/gem ['"]annotaterb['"]/)
      expect(gemfile).not_to match(/gem ['"]annotate['"]/)
    end
  end

  describe 'app server' do
    it 'removes config/puma.rb' do
      expect(File).not_to exist(project_file('config', 'puma.rb'))
    end

    it 'runs falcon from bin/dev' do
      expect(read_project_file('bin', 'dev')).to include('falcon serve')
    end

    it 'runs falcon behind thruster from the Dockerfile CMD' do
      content = read_project_file('Dockerfile')
      expect(content).to include('CMD ["./bin/thrust", "sh", "-c"')
      expect(content).to include('falcon serve --bind http://0.0.0.0:$PORT')
      expect(content).not_to include('"./bin/rails", "server"')
    end

    it 'installs thruster' do
      expect(read_project_file('Gemfile')).to match(/gem ['"]thruster['"]/)
    end
  end

  describe 'rubocop' do
    subject(:config) { read_project_file('.rubocop.yml') }

    it 'inherits rubocop-rails-omakase' do
      expect(config).to include('rubocop-rails-omakase')
    end

    it 'does not pin a TargetRubyVersion' do
      expect(config).not_to include('TargetRubyVersion')
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

  describe 'testing' do
    it 'uses minitest, not rspec' do
      expect(File).to exist(project_file('test', 'test_helper.rb'))
      expect(File).not_to exist(project_file('spec'))
      expect(read_project_file('Gemfile')).not_to match(/gem ['"]rspec/)
    end

    it 'installs the bankai test_helper' do
      content = read_project_file('test', 'test_helper.rb')
      expect(content).to include('FactoryBot::Syntax::Methods')
      expect(content).to include('use_transactional_tests = false')
    end

    %w[coverage shoulda_matchers database_rewinder].each do |support|
      it "generates test/support/#{support}.rb" do
        expect(File).to exist(project_file('test', 'support', "#{support}.rb"))
      end
    end

    it 'runs minitest in CI' do
      expect(read_project_file('.gitlab-ci.yml')).to include('bin/rails test')
    end
  end

  describe 'configuration injection' do
    it 'disables helper generation in application.rb' do
      content = read_project_file('config', 'application.rb')
      expect(content).to include('generate.helper false')
    end

    it 'configures quiet assets in application.rb' do
      content = read_project_file('config', 'application.rb')
      expect(content).to include('config.assets.quiet = true')
    end

    it 'configures the .test dev host in development.rb' do
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
      test/factories/.keep
      test/requests/.keep
      test/support/matchers/.keep
      test/support/mixins/.keep
    ].each do |path|
      it "creates #{path}" do
        expect(File).to exist(project_file(path))
      end
    end
  end
end
