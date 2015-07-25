require "securerandom"

class Soul

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid[0,8]
  end

end
