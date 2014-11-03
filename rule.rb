class Rule

  def initialize grammar, rule, rosecode
    @rule  = parse(rule)
    @rosecode = rosecode
    @grammar = grammar
    @lexicon = grammar.lexicon
  end

  def parse rule
    parsed = []
    rule.split.each do |token|
      form = /{(.+)}/.match(token)
      if form
        parsed << { type: :form, text: form[1] }
      else
        parsed << { type: :literal, text: token }
      end
    end
    return parsed
  end
  
  def match text
    tokens = text.split
    return false unless tokens.size == @rule.size
    #Map literals first
    @rule.each_with_index do |r, i|
      next if r[:type] != :literal
      return false if tokens.index(r[:text]) == nil
    end
    #Then find forms
    forms = []
    @rule.each_with_index do |r, i|
      next if r[:type] != :form
      lexemes = @lexicon.lexemes_by_form(r[:text])
      return false unless lexemes
      #TODO: what if more than one lexeme exists?
      candidate = lexemes.find do |lexeme|
        matches = nil
        lexeme.conjugate(r[:text]).each do |conjugation|
          matches ||= tokens.index(conjugation)
        end
        !!matches
      end
      return false unless candidate
      forms << tokens.index(candidate.conjugate(r[:text]))
    end
    return true
  end

  def codify text
    @rosecode if match? text
  end

end
