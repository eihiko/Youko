class Form

  def initialize lexicon, name, rosecode, parent
    @lexicon = lexicon
    @name = name
    @rosecode = rosecode
    @parent = parent
    @children = []
  end

  def add_form name, rosecode
    @children << @lexicon.add_form name, rosecode, self
  end

end



