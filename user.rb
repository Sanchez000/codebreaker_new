# frozen_string_literal: true

class User
  attr_accessor :name
  BASE_NAME_LENGTH = (3..20).freeze
  # include Validate
  
  def initialize(name)
    @name = name
  end

  def valid?
    name_proc_validator.call(@name)
  end

  private

  def name_proc_validator
    proc do |name|
      range_checker([name.size], BASE_NAME_LENGTH)
    end
  end
  
  def range_checker(entity, range)
    entity.all? { |digit| range.include?(digit) }
  end
end