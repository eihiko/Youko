require "./rule.rb"

class Grammar

  attr_reader :lexicon
  attr_reader :rules

  def initialize lexicon
    @rules = []
    @lexicon = lexicon
  end

  def add_rule rule, rosecode
    @rules << Rule.new(self, rule, rosecode)
  end

  def match text
    @rules.find_all do |rule|
      rule.match? text
    end
  end

end
