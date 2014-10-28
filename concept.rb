require "securerandom"

class Concept

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid
  end

end
