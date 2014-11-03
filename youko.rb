require "./Corr/corr.rb"
require "./Corr/adaptor.rb"


class Youko

  attr_reader :grammar

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
      replies << message
    end
    corr.tell *replies
    sleep 1
  end

  def codify message
    codes = "";
    matches = @grammar.match(message)
    matches.each do |rule|
      codes << rule.codify(message) + "; "
    end
    codes << "I cannot parse your text." if matches.empty?
    return codes
  end

end

