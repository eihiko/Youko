class Looter

  def self.loot hash
    return [hash] unless hash.respond_to? :values
    hash.flat_map { |k,v| loot v }
  end

end
