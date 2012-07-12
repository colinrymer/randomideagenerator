require 'json'
%w( categories randompage ideagenerator database ).each {|lib| require "./lib/#{lib}" }

class Ideas
  def self.create
    IdeaGenerator.new(CATEGORIES)
  end

  def self.good
    get '1', '+inf'
  end

  def self.bad
    get '-inf', '0'
  end

  def self.update(idea)
    Database.update(idea)
  end

  private
  def self.get(min, max)
    Database.fetch(min, max)
  end
end