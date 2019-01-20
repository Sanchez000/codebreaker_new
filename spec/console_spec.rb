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
      #allow_any_instance_of(Console).to receive(:gets).and_return('Vasya')
      allow_any_instance_of(Console).to receive(:game_guess)
      allow_any_instance_of(Console).to receive(:game_guess).and_return('1234')
      # allow_any_instance_of(Console).to receive(:gets).and_return('exit')
      #binding.pry
      #allow_any_instance_of(Console).to receive(:game_guess).with('1234')
      #allow_any_instance_of(Console).to receive(:gets).and_return('exit')
      expect_any_instance_of(Console).to receive(:take_and_save_user)
      expect_any_instance_of(Console).to receive(:choose_the_difficulty)
      #expect_any_instance_of(Console).to receive(:game_guess)
      described_class.new.start
    end
  end
end
