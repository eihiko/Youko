require "./lexeme.rb"

class Lexicon

  def initialize
    @forms = {}
    @lexemes = []
  end

  def add_form name, rosecode, parent = nil
    form = Form.new(self, name, rosecode, parent)
    @forms[name] = form
    return form
  end

  def add_lexeme concept, forms
    @lexemes << Lexeme.new(self, concept, forms)
  end

  def lexemes_by_form form
    form = form.to_sym
    @lexemes.find_all do |lexeme|
      lexeme.conjugate(form) != nil
    end
  end

end
