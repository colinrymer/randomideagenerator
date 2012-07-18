require 'redis'

class Database
  def self.fetch_ideas(min, max)
    redis.zrevrangebyscore(:ideas, max, min, withscores: true).map{|idea| { idea: JSON.parse(idea.first)['idea'], categories: JSON.parse(idea.first)['categories'], score: idea.last } }
  end

  def self.update_idea(idea, categories, score)
    redis.zincrby(:ideas, score, format_idea(idea, categories))
  end

  def self.remove_idea(idea, categories)
    format_idea(idea, categories)
  end

  def self.all_categories
    redis.smembers :categories
  end

  def self.add_category(category)
    redis.sadd :categories, category
  end

  def self.remove_category(category)
    redis.srem :categories, category
  end

  def self.remove_all_categories
    redis.del :categories
  end

  def self.random_category
    redis.srandmember :categories
  end

  private
  def self.format_idea(idea, categories)
    { idea: idea, categories: categories }.to_json
  end

  def self.redis
    if ENV["REDISTOGO_URL"]
      uri = URI.parse(ENV["REDISTOGO_URL"])
      @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      @redis ||= Redis.new
    end
  end
end