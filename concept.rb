require "securerandom"

class Concept

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid[0,8]
    @is = {}
    @has = {}
  end

  def id
    @id
  end

  def is concept, condition=1
    @is[concept] = condition
  end

  def is? concept, condition=1
    return true if @is[concept] == condition
    @is.keys.each do |is|
      return true if is.us? concept, condition
    end
    return false
  end


  def has concept, condition=1
    @has[concept] = condition
  end

  def all_is
    @is
  end

  def all_has
    @has
  end

end
