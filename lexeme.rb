require './looter.rb'

class Lexeme

  attr_reader :forms

  def initialize lexicon, concept, forms
    @lexicon = lexicon
    @concept = concept
    @forms = forms
  end

  #TODO: use Looter.track
  def conjugate form, form_hash=@forms
    form = form.to_sym
    return Looter.loot(form_hash[form]) unless form_hash[form].nil?
    form_hash.each do |k,v|
      return conjugate(form, v) if v.respond_to? :to_hash
    end
    return nil
  end
  
  def form_to_rosecode form
    form = form.to_sym
    parents = Looter.track @forms, form
    code = ""
    parents.each do |f|
      code = f[1].gsub("%",code).gsub("[]",@concept.id)
    end
    return code
  end

end
