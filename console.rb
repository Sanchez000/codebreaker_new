require 'pry'
# some top comment
class Console
  attr_reader :user
  attr_accessor :game
  
  COMMANDS = {
    start: 'start',
    rules: 'rules',
    stats: 'stats',
    exit: 'exit'
  }.freeze
  
  GAMEPLAY_COMMANDS = {
    hint: 'hint',
    restart: 'restart',
    save: 'save'
  }

  def show_message(command, **hash)
    puts I18n.t(command, **hash)
  end

  def main_menu
    show_message(:welcome)
    loop do
      show_message(:menu_options, options: COMMANDS.values.join(' | '))
      input = gets.chomp.downcase
      menu_options(input) ### return after choose one of the right option
    end
  end

  def menu_options(input)
    case input
    when COMMANDS[:start] then return start
    when COMMANDS[:rules] then show_message(:rules)
    when COMMANDS[:stats] then stats
    when COMMANDS[:exit] then quit
    else show_message(:unexpected_command)
    end
  end

  def quit
    show_message(:bye)
    exit
  end

  def start
    take_and_save_user
    level = choose_the_difficulty
    @game = Game.new(@user, level.to_sym)
    game_process
  end

  def game_process
    loop do
      @round_result = game_guess
      break if @round_result == Game::ALL_GUESSED_RIGHT || game.attempts_left == 0
    end
    @round_result == Game::ALL_GUESSED_RIGHT ? game_win : game_lose
  end

  def game_guess
    show_message(:enter_your_guess)
    guess = gets.chomp
    return game_hint if guess == GAMEPLAY_COMMANDS[:hint]
    
    return exit if guess == COMMANDS[:exit]
    
    return show_message(:not_allowed) unless guess_valid?(guess)
    
    show_message(:round_result, result: game.fetch_guess(guess))
    game.fetch_guess(guess)
  end
  
  def game_hint
    game.hints_left.positive? ? show_message(:hint, digit: game.get_hint) : show_message(:no_hints)
  end

  def guess_valid?(guess)
     guess = array_converter(guess)
     range_checker(guess, Game::CODE_RANGE) if size_measurer(guess, Game::CODE_SIZE)
  end
  
  def size_measurer(entity, length)
    entity.size == length
  end

  def range_checker(entity, range)
    entity.all? { |digit| range.include?(digit) }
  end
  
  def array_converter(array)
    array.split('').map(&:to_i)
  end

  def choose_the_difficulty
    loop do
      show_message(:choose_difficult, options: Game::LEVELS_NAMES.keys.join(', '))
      answer = gets.chomp
      exit if answer == COMMANDS[:exit]
      
      show_message(:unexpected_command) unless Game::LEVELS_NAMES.keys.include?(answer.to_sym)
      
      return answer if Game::LEVELS_NAMES.keys.include?(answer.to_sym)
    end
  end

  def take_and_save_user
    loop do
      show_message(:give_us_your_name)
      answer = gets.chomp
      exit if answer == COMMANDS[:exit]

      @user = User.new(answer)
      break if user.valid?
  
      show_message(:invalid_name) unless user.valid?
    end
  end
  
  def stats
    archive = Game.storage
    puts archive.to_s
  end
  
  def want_to_save_game?
    show_message(:ask_for_save)
    answer = gets.chomp
    answer == 'Y'
  end
  
  def want_to_restart?
    show_message(:want_restart)
    answer = gets.chomp
    answer == 'Y'
  end
  
  private
  
  def game_win
    show_message(:game_result, stage: 'win', code: game.get_right_code) # code smell --> get right code
    game.save if want_to_save_game?
    start if want_to_restart?
    exit
  end
  
  def game_lose
    show_message(:game_result, stage: 'lose', code: game.get_right_code)
    start if want_to_restart?
    exit
  end
end
