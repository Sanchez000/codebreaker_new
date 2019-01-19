class Console
  attr_accessor :game, :user

  include Validator

  COMMANDS = {
    start: 'start',
    rules: 'rules',
    stats: 'stats',
    exit: 'exit'
  }.freeze

  GAMEPLAY_COMMANDS = {
    hint: 'hint',
    restart: 'restart',
    save: 'save',
    yes: 'Y'
  }.freeze

  def show_message(command, **hash)
    puts I18n.t(command, **hash)
  end

  def main_menu
    show_message(:welcome)
    loop do
      show_message(:menu_options, options: COMMANDS.values.join(' | '))
      menu_options(gets.chomp.downcase)
    end
  end

  def menu_options(input)
    case input
    when COMMANDS[:start] then start
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
      show_message(:enter_your_guess)
      guess = gets.chomp
      @round_result = game_guess(guess)
      break if @round_result == Game::ALL_GUESSED_RIGHT || game.attempts_left.zero?
    end
    @round_result == Game::ALL_GUESSED_RIGHT ? game_result(Game::STATUSES[:win]) : game_result(Game::STATUSES[:lose])
  end

  def game_guess(guess)
    return game_hint if guess == GAMEPLAY_COMMANDS[:hint]

    return exit if guess == COMMANDS[:exit]

    return show_message(:not_allowed) unless guess_valid?(guess)

    temp_round_result = game.fetch_guess(guess)
    show_message(:round_result, result: temp_round_result) if guess_valid?(guess)
    temp_round_result
  end

  def game_hint
    game.hints_left.positive? ? show_message(:hint, digit: game.hint) : show_message(:no_hints)
  end

  def choose_the_difficulty
    loop do
      show_message(:choose_difficult, options: Game::LEVELS_NAMES.keys.join(', '))
      answer = gets.chomp
      exit if answer == COMMANDS[:exit]

      show_message(:unexpected_command) unless Game::LEVELS_NAMES.key?(answer.to_sym)

      return answer if Game::LEVELS_NAMES.key?(answer.to_sym)
    end
  end

  def take_and_save_user
    loop do
      show_message(:give_us_your_name)
      answer = gets.chomp
      exit if answer == COMMANDS[:exit]

      @user = User.new(answer)
      break if @user.valid?

      show_message(:invalid_name, min: User::NAME_LENGTH.begin, max: User::NAME_LENGTH.end)
    end
  end

  def stats
    archive = Game.storage
    puts archive.to_s
  end

  def want_to?(command)
    command == GAMEPLAY_COMMANDS[:restart] ? show_message(:want_restart) : show_message(:ask_for_save)
    answer = gets.chomp
    answer == GAMEPLAY_COMMANDS[:yes]
  end

  private

  def game_result(status)
    show_message(:game_result, stage: status, code: game.right_code)
    if status == Game::STATUSES[:win]
      game.save if want_to?(GAMEPLAY_COMMANDS[:save])
    end
    start if want_to?(GAMEPLAY_COMMANDS[:restart])
    exit
  end
end
