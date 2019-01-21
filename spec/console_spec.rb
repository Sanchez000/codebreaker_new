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

RSpec.describe Console do
  describe '#show_message' do
    it 'takes command and hash params and print it to console' do
      expect(STDOUT).to receive(:puts).with(I18n.t(:rules))
      described_class.new.show_message(:rules)
    end
  end

  describe '#main_menu' do
    it 'start the game from command - start' do
      expect_any_instance_of(Console).to receive(:start).once
      described_class.new.menu_options(Console::COMMANDS[:start])
    end
    it 'show rules of game from command - rules' do
      expect_any_instance_of(Console).to receive(:show_message).with(:rules)
      described_class.new.menu_options(Console::COMMANDS[:rules])
    end
    it 'exit from game by command - exit' do
      expect_any_instance_of(Console).to receive(:exit)
      described_class.new.menu_options(Console::COMMANDS[:exit])
    end
    it 'show stats of game by command - stats' do
      expect_any_instance_of(Console).to receive(:stats)
      described_class.new.menu_options(Console::COMMANDS[:stats])
    end
    it 'show error if command not exist' do
      expect_any_instance_of(Console).to receive(:show_message).with(:unexpected_command)
      described_class.new.menu_options('some new command')
    end
  end

  describe '#start' do
    it 'ask user name and save it to User instance' do
      allow_any_instance_of(Console).to receive(:choose_the_difficulty).and_return('easy')
      allow_any_instance_of(Console).to receive(:game_guess).and_return('++++')
      allow_any_instance_of(Console).to receive(:want_to?).and_return(false)
      expect_any_instance_of(Console).to receive(:take_and_save_user)
      expect_any_instance_of(Console).to receive(:choose_the_difficulty)
      expect_any_instance_of(Console).to receive(:game_process)
      described_class.new.start
    end
  end

  describe '#game_guess(guess)' do
    it 'take guess, validate and return error if guess is not valid' do
      console = described_class.new
      expect_any_instance_of(Console).to receive(:show_message).with(:not_allowed)
      console.game_guess('+++6')
    end
    it 'return hint if command get hint' do
      console = described_class.new
      expect_any_instance_of(Console).to receive(:game_hint)
      console.game_guess(Console::GAMEPLAY_COMMANDS[:hint])
    end
    it 'return round result if guess are valid' do
      console = described_class.new
      user = double('User', name: 'Petya')
      level = :easy
      console.game = Game.new(user, level)
      allow_any_instance_of(Game).to receive(:secret).and_return([4, 2, 3, 1])
      expect(STDOUT).to receive(:puts).with(I18n.t(:round_result, result: '++--'))
      console.game_guess('1234')
    end
  end

  describe '#game_hint' do
    it 'return hint if counter hint more then zero' do
      console = described_class.new
      user = double('User', name: 'Petya')
      level = :easy
      console.game = Game.new(user, level)
      expect(console).to receive(:show_message)
      console.game_hint
    end
  end

  describe '#want_to?' do
    it 'return true if user answer equivalent  -> Y' do
      allow_any_instance_of(Console).to receive(:gets).and_return(Console::GAMEPLAY_COMMANDS[:yes])
      expect(described_class.new.want_to?(Console::GAMEPLAY_COMMANDS[:restart])).to be true
    end
    it 'return false if user answer not equivalent  -> Y' do
      allow_any_instance_of(Console).to receive(:gets).and_return('n')
      expect(described_class.new.want_to?(Console::GAMEPLAY_COMMANDS[:save])).to be false
    end
  end

  describe '#take_and_save_user' do
    it 'gets player name and validate it' do
      console = described_class.new
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow(console).to receive(:gets).and_return('Vasya')
      #expect(console).to receive(:show_message).with(:give_us_your_name)
      console.take_and_save_user
      expect(console.user).to be_instance_of(User)
    end
    it 'return error if user name length is not valid' do
      console = described_class.new
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow(console).to receive(:gets).and_return('++')
      expect(console).to receive(:show_message).with(:give_us_your_name)
      expect(console).to receive(:show_message).with(:invalid_name,min: User::NAME_LENGTH.begin, max: User::NAME_LENGTH.end)
      console.take_and_save_user
    end
  end

  describe '#choose_the_difficulty' do
    it 'return error if user entered not correct difficulty' do
      console = described_class.new
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow(console).to receive(:gets).and_return('hel')
      expect(console).to receive(:show_message).with(:choose_difficult, options: Game::LEVELS_NAMES.keys.join(', '))
      expect(console).to receive(:show_message).with(:unexpected_command)
      console.choose_the_difficulty
    end
    it 'return choosen difficulty if user entered valid answer' do
      console = described_class.new
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow(console).to receive(:gets).and_return('hell')
      expect(console).to receive(:show_message).with(:choose_difficult, options: Game::LEVELS_NAMES.keys.join(', '))
      expect(console.choose_the_difficulty).to eq 'hell'
    end
  end

  describe '#game_process' do
    it 'ask user to enter guess and validate it' do
      console = described_class.new
      user = double('User', name: 'Petya')
      level = :easy
      console.game = Game.new(user, level)
      allow_any_instance_of(Game).to receive(:secret).and_return([1, 2, 3, 4])
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow(console).to receive(:gets).and_return('1234')
      expect(console).to receive(:game_result).with(Game::STATUSES[:win])
      console.game_process
    end
  end
  
  describe '#main_menu' do
    it 'print welcome message' do
      console = described_class.new
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow(console).to receive(:gets).and_return('')
      expect(console).to receive(:show_message).with(:welcome)
      expect(console).to receive(:show_message).with(:menu_options, options: Console::COMMANDS.values.join(' | '))
      expect(console).to receive(:show_message).with(:unexpected_command)
      console.main_menu
    end
  end

  describe 'game_result' do
    it 'offers to save result of game if game state win' do
      console = described_class.new
      allow(console).to receive(:want_to?).with(Console::GAMEPLAY_COMMANDS[:save]).and_return(true)
      allow(console).to receive(:want_to?).with(Console::GAMEPLAY_COMMANDS[:restart]).and_return(false)
      user = double('User', name: 'Petya')
      level = :easy
      console.game = Game.new(user, level)
      expect(console).to receive(:show_message).with(:game_result, stage: Game::STATUSES[:win], code: console.game.secret_code)
      expect(console).to receive(:show_message).with(:ask_for_save)
      expect(console).to receive(:show_message).with(:want_restart)
      console.send(:game_result, Game::STATUSES[:win])
    end
  end
end
