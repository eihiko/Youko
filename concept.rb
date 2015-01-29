require "securerandom"

class Concept

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid[0,8]
  end

end
