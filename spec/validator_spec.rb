# frozen_string_literal: true

require 'pry'
require 'validator'
require 'loader'
require 'console'
require 'user'
require 'game'

class DummyClass
  include Validator
end

RSpec.describe Validator do
  describe '#guess_valid?' do
    context 'validate guess of game' do
      it 'return true if guess have valid size and is in the right range' do
        right_guess = '1234'
        dc = DummyClass.new
        expect(dc.guess_valid?(right_guess)).to be_truthy
      end
      it 'return false if guess have invalid size or is not in the right range' do
        invalid_guess = '8904'
        invalid_guess_second = '12345'
        dc = DummyClass.new
        expect(dc.guess_valid?(invalid_guess)).to be_falsey
        expect(dc.guess_valid?(invalid_guess_second)).to be_falsey
      end
    end
  end
end
