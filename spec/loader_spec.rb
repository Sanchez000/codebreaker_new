# frozen_string_literal: true

require 'loader'
require 'game'

class DummyClass
  include Loader
end

RSpec.describe Loader do
  describe "#save(game)" do
    it 'writes the specified content' do
      dc = DummyClass.new
      local_filename = Game::PATH_TO_DB
      user = double('User', name: 'Petya')
      level = :easy
      game = Game.new(user, level)
      expect(File).to receive(:open).with(local_filename, 'w')
      dc.save(game)
    end
  end
end
