class Game
  attr_reader :user, :level, :hints_total, :attempts_total, :hints_left, :attempts_left

  PATH_TO_DB = 'stats.yml'.freeze
  LABEL_GUESSED_RIGHT = '+'.freeze
  LABEL_GUESSED_WRONG = '-'.freeze
  ALL_GUESSED_RIGHT = '++++'.freeze
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
  end
  
  def self.storage
    @@list_of_games ||= File.exist?(PATH_TO_DB) ? YAML.load_file(PATH_TO_DB) : []
  end
  
  def fetch_guess(guess)
    @attempts_left -= 1
    guess = guess.split('').map(&:to_i)
    pluses(guess) + minuses(guess)
  end

  def get_hint
    @@shuffled ||= secret.shuffle
    @hints_left -= 1
    @@shuffled.pop
  end
  
  def get_right_code
    secret.join(', ')
  end
  
  def save
    File.open(PATH_TO_DB, 'w') { |file| file.write self.to_yaml }
  end

  private
  
  def secret
    @@code ||= Array.new(CODE_SIZE) { rand(CODE_RANGE) }
  end
    
  def pluses(input)
    secret.zip(input).map { |a, b| a == b ? LABEL_GUESSED_RIGHT : '' }.join('')
  end

  def minuses(input)
    match = secret.zip(input).map { |a, b| b if a == b }.compact
    no_match = secret.zip(input).map { |a, b| b if a != b }.compact.uniq
    origonal_left = (secret - match).uniq
    str = ''
    no_match.each { |digit| str += LABEL_GUESSED_WRONG if origonal_left.include?(digit) }
    str
  end
end