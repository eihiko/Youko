require "./Corr/corr.rb"
require "./Corr/adaptor.rb"
require "./concept.rb"
require "./lexicon.rb"
require "./grammar.rb"


class Youko

  def initialize
    puts "Youko is waking up!"
    print " ~ Loading Corrs... "
    Dir["./Corr/*/*_corr.rb"].each { |corr| require corr }
    puts "loaded."
    print " ~ Loading Adaptors... "
    Dir["./Corr/*/*_adaptor.rb"].each { |adaptor| require adaptor }
    puts "loaded."
    print " ~ Initializing Adaptors... "
    @adaptors = Adaptor.adaptors.map { |adaptor| adaptor.new }
    puts "initialized."
    print " ~ Conceptualizing concepts..."
    @dog = Concept.new
    @to_be = Concept.new
    puts "conceptualized."
    print " ~ Populating Lexicon..."
    @lexicon = Lexicon.new
    @lexicon.add_form(:noun, "[]")
    @lexicon.add_form(:singular, "%")
    @lexicon.add_form(:plural, "%#")
    @lexicon.add_form("verb", "[]")
    @lexicon.add_form(:present, "%")
    @lexicon.add_form(:past, "%:<")
    @lexicon.add_lexeme(@dog, noun: { singular: "dog", plural: "dogs" })
    @lexicon.add_lexeme(@to_be, verb: { present: "is", past: "was" })
    puts "populated."
    print " ~ Building Grammar..."
    @grammar = Grammar.new(@lexicon)
    @grammar.add_rule("there {verb} a {noun}", "(+{noun})={verb}")
    puts "built."
    puts "おはよう、ようこ!"
  end

  def wake_up
    @awake = true
    while @awake
      @adaptors.each do |adaptor|
        adaptor.corrs.each do |corr|
          talk_to(corr)
        end
      end
    end
  end

  def goto_sleep
    @awake = false
  end

  def talk_to corr
    messages = corr.listen
    replies = []
    messages.each do |message|
      replies << codify(message)
    end
    corr.tell *replies
    sleep 1
  end

  def codify message
    message
  end

end

