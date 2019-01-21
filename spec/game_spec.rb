# frozen_string_literal: true

RSpec.describe Game do
  describe '#initialize' do
    context 'will get user' do
      it 'and save user name' do
        user = double('User', name: 'Petya')
        level = :easy
        game = Game.new(user, level)
        expect(game.class).to eq(Game)
        expect(game.user.name).to eq('Petya')
      end
    end
  end

  describe '#fetch_guess' do
    it 'takes guess and calculate temporary round result' do
      user = double('User', name: 'Petya')
      level = :easy
      game = Game.new(user, level)
      guess = '6543'
      allow_any_instance_of(Game).to receive(:secret).and_return([5, 6, 4, 3])
      expect(game.fetch_guess(guess)).to eq '++--'
    end
    it 'substract count of total attempts' do
      user = double('User', name: 'Petya')
      level = :easy
      game = Game.new(user, level)
      guess = '6543'
      allow_any_instance_of(Game).to receive(:secret).and_return([5, 6, 4, 3])
      game.fetch_guess(guess)
      expect(game.attempts_left).to eq 14
    end
  end

  describe '#hint' do
    it 'takes command hint and return one of digit from secret code' do
      user = double('User', name: 'Petya')
      level = :hell
      game = Game.new(user, level)
      secret_code = [5, 6, 4, 3]
      allow_any_instance_of(Game).to receive(:secret).and_return(secret_code)
      expect(secret_code).to include(game.hint)
      expect(game.hints_left).to be 0
    end
  end
end
