require_relative "Corr/corr"
require_relative "Corr/adaptor"
require_relative "concept"
require_relative "soul"
require_relative "lexicon"
require_relative "rose"
require "logger"

class Youko

  attr_reader :grammar, :lexicon, :concepts

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
    print " ~ Kindling Soul... "
    @soul = Soul.new
    puts "kindled."
    print " ~ Conceptualizing concepts... "
    @lexicon = Lexicon.new
    @concepts = {}
    puts "conceptualized."
    puts "Ohayou, Youko!"
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
      replies << interpret(message)
    end
    sleep(1)
    corr.tell *replies
  end

  def interpret message
    response = ""
    if message[0,2] == "~~"
      response = interpret_command message[2, message.length]
    elsif message[0,2] == "``"
      response = interpret_rosecode message[2, message.length]
    else
      response = interpret_natural message
    end
    return response
  end

  def interpret_command command
    if command == "sleep"
      exit(0)
    elsif command == "dump"
      dump = "DUMP\n-----\n"
      @concepts.each do |id, concept|
        dump << "#{concept.id} (#{@lexicon.find concept})\n"
        dump << "  IS:\n"
        concept.all_is.each do |is, condition|
          dump << "     #{is.id} [#{condition}] (#{@lexicon.find is})\n"
        end
        dump << "  HAS:\n"
        concept.all_has.each do |has, condition|
          dump << "     #{has.id} [#{condition}] (#{@lexicon.find has})\n"
        end
      end
      return dump
    elsif command == "give cookie"
      return "^O^"
    end
  end


  def interpret_rosecode rosecode
    iss = []
    roses = rosecode.split(";")
    roses.map! { |rose| Rose.new(self, rose) }
    response = ""
    roses.each do |rose|
      if rose.question?
        response << "Yes. " if rose.true? == 1
        response << "No. " if rose.true? == 0
        response << "I don't know. " if rose.true? == -1
      else
        rose.learn
        response << "Okay. "
      end
    end
    return response
  end

  def interpret_natural message
    return message
  end      
      



      
end

