class User
  attr_accessor :name

  include Validator

  NAME_LENGTH = (3..20).freeze

  def initialize(name)
    @name = name
  end

  def valid?
    name_proc_validator.call(@name)
  end

  private

  def name_proc_validator
    proc do |name|
      range_checker([name.size], NAME_LENGTH)
    end
  end
end
