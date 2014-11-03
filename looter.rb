class Looter

  def self.loot hash
    return [hash] unless hash.respond_to? :values
    hash.flat_map { |k,v| loot v }
  end

  def self.track hash, item
    chain = []
    return nil unless hash.respond_to? :keys
    hash.each do |k,v|
      return [k] if k == item
      found = infiltrate(v, item) if v.respond_to? :keys
      return [k] + found unless found.nil?
    end
    return nil
  end

end
