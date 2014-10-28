require "./lexeme.rb"

class Lexicon

  def initialize
    @forms = {}
    @lexemes = []
  end

  def add_form form, rosecode
    @forms[form] = rosecode
  end

  def add_lexeme concept, forms
    @lexemes << Lexeme.new(concept, forms)
  end

end
