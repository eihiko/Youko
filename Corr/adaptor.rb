require 'pry'

module Adaptor
  
  def self.included base
    @adaptors ||= []
    @adaptors << base
  end

  def self.adaptors
    @adaptors
  end

  def corrs
    fail "All Adaptors must implement a corrs() method"
  end

end
