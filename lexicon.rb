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

  def lexemes_by_form form
    form = form.to_sym
    @lexemes.find_all do |lexeme|
      lexeme.conjugate(form) != nil
    end
  end

end
