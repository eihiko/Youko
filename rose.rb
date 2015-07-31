require "securerandom"

class Rose

  attr_reader :id

  def initialize youko, rosecode
    @id = SecureRandom.uuid[0,8]
    @youko = youko
    @rosecode = rosecode
    @question = (@rosecode[0] == "?")
    @rosecode = @rosecode[1, @rosecode.length] if @question
    @left = nil
    @right = nil
    @op = nil
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

  def parse
    if @rosecode[0] == "("
      left = ""
      paren = 1
      i = 1
      loop do
        break if i >= @rosecode.length
        c = @rosecode[i]
        i += 1
        paren += 1 if c == "("
        paren -= 1 if c == ")"
        break if paren <= 0
        left << c
      end
      @left = Rose.new(@youko, left)
      @op = @rosecode[i]
      @right = Rose.new(@youko, @rosecode[i+1, @rosecode.length])
      return [@left.parse, @op, @right.parse]
    else
      i = @rosecode.index /[=]/
      i ||= @rosecode.index /[+]/
      return @rosecode if i.nil?
      @left = Rose.new(@youko, @rosecode[0,i])
      @op = @rosecode[i]
      @right = Rose.new(@youko, @rosecode[i+1, @rosecode.length])
      return [@left.parse, @op, @right.parse]
    end
  end


  def learn
    is = @rosecode.split("=")
    has = is.each { |i| i.split(".") }
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
