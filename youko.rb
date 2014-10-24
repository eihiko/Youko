require "./Corr/corr.rb"
require "./Corr/adaptor.rb"

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
    puts messages
    corr.tell *messages
    sleep 1
  end

end

