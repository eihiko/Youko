require "securerandom"

class Lexicon

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid[0,8]
    @lexicon = Hash.new {|h,k| h[k] = []}
  end

  def id
    @id
  end

  def add word, concept
    @lexicon[word] << concept
  end

  def find item
    if item.class == Concept
      w = []
      @lexicon.each do |word, concepts|
        w << word if concepts.include? item
      end
      return w
    end
    return @lexicon[item]
  end


end
