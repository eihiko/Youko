require "./rule.rb"

class Grammar

  def initialize lexicon
    @rules = []
    @lexicon = lexicon
  end

  def add_rule rule, rosecode
    @rules << Rule.new(rule, rosecode)
  end

end
