require "securerandom"

class Grammar

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid[0,8]
    @rules = []
  end

  def id
    @id
  end

  def add rule, rosecode
    @rules << [rule, rosecode]

end
