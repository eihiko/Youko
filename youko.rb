require "./Corr/corr.rb"
require "./Corr/adaptor.rb"
require "./concept.rb"
require_relative "soul"
require_relative "lexicon"
require "logger"

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
    end
  end


  def interpret_rosecode rosecode
    iss = []
    clauses = rosecode.split(";")
    clauses.each do |clause|
      iss << clause.split("=")
    end
    iss.each do |is|
      first = @lexicon.find(is[0]).first
      if first.nil?
        first = Concept.new
        @lexicon.add is[0], first
      end
      second = @lexicon.find(is[1]).first
      if second.nil?
        second = Concept.new
        @lexicon.add is[1], second
      end
      @concepts[first.id] = first
      @concepts[second.id] =  second
      first.is second
    end
    return "Got it."
  end

  def interpret_natural message
    return message
  end      
      



      
end

