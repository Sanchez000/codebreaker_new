class Game
  attr_reader :user, :level, :hints_total, :attempts_total, :hints_left, :attempts_left, :secret_code

  PATH_TO_DB = 'stats.yml'.freeze
  LABEL_GUESSED_RIGHT = '+'.freeze
  LABEL_GUESSED_WRONG = '-'.freeze
  ALL_GUESSED_RIGHT = '++++'.freeze
  STATUSES = { win: 'win', lose: 'lose' }.freeze
  CODE_SIZE = 4
  CODE_RANGE = (1..6).freeze
  LEVELS_NAMES = {
    easy: {
      attempts: 15,
      hints: 2
    },
    medium: {
      attempts: 10,
      hints: 1
    },
    hell: {
      attempts: 5,
      hints: 1
    }
  }.freeze

  def initialize(user, level)
    @user = user
    @level = level
    @hints_total = LEVELS_NAMES[level][:hints]
    @attempts_total = LEVELS_NAMES[level][:attempts]
    @hints_left = @hints_total
    @attempts_left = @attempts_total
    @secret_code = secret
  end

  def fetch_guess(guess)
    @attempts_left -= 1
    guess = guess.split('').map(&:to_i)
    pluses(guess) + minuses(guess)
  end

  def hint
    @shuffled ||= secret.shuffle
    @hints_left -= 1
    @shuffled.pop
  end

  private

  def secret
    @secret ||= Array.new(CODE_SIZE) { rand(CODE_RANGE) }
  end

  def pluses(input)
    secret.zip(input).map { |a, b| a == b ? LABEL_GUESSED_RIGHT : '' }.join('')
  end

  def minuses(input)
    guessed = match(input)
    not_guessed = no_match(input)
    original_left = (secret - guessed).uniq
    str = ''
    not_guessed.each { |digit| str += LABEL_GUESSED_WRONG if original_left.include?(digit) }
    str
  end

  def match(input)
    secret.zip(input).map { |a, b| b if a == b }.compact
  end

  def no_match(input)
    secret.zip(input).map { |a, b| b if a != b }.compact.uniq
  end
end
