class User
  attr_accessor :name

  include Validator

  NAME_LENGTH = (3..20).freeze

  def initialize(name)
    @name = name
  end

  def valid?
    range_checker([name.size], NAME_LENGTH)
  end
end
