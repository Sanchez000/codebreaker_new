# frozen_string_literal: true

require 'i18n'
require 'pry'
require 'validator'
require 'loader'
require 'console'
require 'user'
require 'game'

I18n.load_path << Dir[File.expand_path('lib/config/locales') + '/*.yml']
I18n.default_locale = :en

RSpec.describe User do
  describe '#valid?' do
    context 'validate length name' do
      it 'return true if name have valid length' do
        valid_name = 'Petya Poroh'
        valid_user = User.new(valid_name)
        expect(valid_user.valid?).to be_truthy
      end
      it 'return false if name length is not valid' do
        invalid_name = 'po'
        invalid_user = User.new(invalid_name)
        expect(invalid_user.valid?).to be_falsey
      end
    end
  end
end
