require "securerandom"

class Rose

  attr_reader :id

  def initialize youko, rosecode
    @id = SecureRandom.uuid[0,8]
    @youko = youko
    @rosecode = rosecode
    @question = (@rosecode[0] == "?")
    @rosecode = @rosecode[1, @rosecode.length] if @question
    @concepts = {}
  end

  def id
    @id
  end

  def question?
    @question
  end
  
  def true?
    is = @rosecode.split("=")
    first = @youko.lexicon.find(is[0]).first
    second = @youko.lexicon.find(is[1]).first
    return -1 if first.nil? or second.nil?
    return 1 if first.is? second
    return 0
  end

  def learn
    is = @rosecode.split("=")
    first = @youko.lexicon.find(is[0]).first
    if first.nil?
      first = Concept.new
      @youko.lexicon.add is[0], first
    end
    second = @youko.lexicon.find(is[1]).first
    if second.nil?
      second = Concept.new
      @youko.lexicon.add is[1], second
    end
    @youko.concepts[first.id] = first
    @youko.concepts[second.id] = second
    first.is second
  end

end
