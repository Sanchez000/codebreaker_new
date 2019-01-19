module Validator
  def size_measurer(entity, length)
    entity.size == length
  end

  def range_checker(entity, range)
    entity.all? { |digit| range.include?(digit) }
  end

  def array_converter(array)
    array.split('').map(&:to_i)
  end

  def guess_valid?(guess)
    guess = array_converter(guess)
    range_checker(guess, Game::CODE_RANGE) if size_measurer(guess, Game::CODE_SIZE)
  end
end
