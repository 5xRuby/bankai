# frozen_string_literal: true

RSpec.describe Bankai do
  describe 'VERSION' do
    it 'is defined' do
      expect(Bankai::VERSION).not_to be_nil
    end

    it 'follows semver format' do
      expect(Bankai::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end

  describe 'RAILS_VERSION' do
    it 'is defined' do
      expect(Bankai::RAILS_VERSION).not_to be_nil
    end

    it 'follows semver format' do
      expect(Bankai::RAILS_VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end

  describe 'RUBOCOP_VERSION' do
    it 'is defined' do
      expect(Bankai::RUBOCOP_VERSION).not_to be_nil
    end

    it 'follows semver format' do
      expect(Bankai::RUBOCOP_VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end

  describe 'CAPISTRANO_VERSION' do
    it 'is defined' do
      expect(Bankai::CAPISTRANO_VERSION).not_to be_nil
    end

    it 'follows semver format' do
      expect(Bankai::CAPISTRANO_VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end
end
