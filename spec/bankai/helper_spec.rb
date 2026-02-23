# frozen_string_literal: true

RSpec.describe Bankai::Helper do
  let(:test_instance) do
    klass = Class.new do
      include Bankai::Helper

      attr_accessor :destination_root

      public :pg?, :mysql?, :capistrano?
    end
    klass.new
  end

  before do
    test_instance.destination_root = '/tmp/fake_app'
  end

  describe '#pg?' do
    it 'returns true when Gemfile contains pg' do
      allow(File).to receive(:read).with('/tmp/fake_app/Gemfile').and_return("gem 'pg'")
      expect(test_instance.pg?).to be true
    end

    it 'returns false when Gemfile contains mysql2' do
      allow(File).to receive(:read).with('/tmp/fake_app/Gemfile').and_return("gem 'mysql2'")
      expect(test_instance.pg?).to be false
    end
  end

  describe '#mysql?' do
    it 'returns true when Gemfile contains mysql2' do
      allow(File).to receive(:read).with('/tmp/fake_app/Gemfile').and_return("gem 'mysql2'")
      expect(test_instance.mysql?).to be true
    end

    it 'returns true when Gemfile contains trilogy' do
      allow(File).to receive(:read).with('/tmp/fake_app/Gemfile').and_return("gem 'trilogy'")
      expect(test_instance.mysql?).to be true
    end

    it 'returns false when Gemfile contains pg' do
      allow(File).to receive(:read).with('/tmp/fake_app/Gemfile').and_return("gem 'pg'")
      expect(test_instance.mysql?).to be false
    end
  end

  describe '#capistrano?' do
    it 'returns true when Gemfile contains capistrano' do
      allow(File).to receive(:read).with('/tmp/fake_app/Gemfile').and_return("gem 'capistrano'")
      expect(test_instance.capistrano?).to be true
    end

    it 'returns false when Gemfile does not contain capistrano' do
      allow(File).to receive(:read).with('/tmp/fake_app/Gemfile').and_return("gem 'pg'")
      expect(test_instance.capistrano?).to be false
    end
  end
end
