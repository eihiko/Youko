require './looter.rb'

class Lexeme

  attr_reader :forms

  def initialize concept, forms
    @concept = concept
    @forms = forms
  end

  def conjugate form, form_hash=@forms
    form = form.to_sym
    return Looter.loot(form_hash[form]) unless form_hash[form].nil?
    form_hash.each do |k,v|
      return conjugate(form, v) if v.respond_to? :to_hash
    end
    return nil
  end

end
