require 'redis'

class Database
  def self.fetch(min, max)
    redis.zrevrangebyscore(:ideas, max, min, withscores: true).map{|idea| { idea: JSON.parse(idea.first)['idea'], categories: JSON.parse(idea.first)['categories'], score: idea.last } }
  end

  def self.update(idea)
    redis.zincrby(:ideas, (idea['direction'] == 'up' ? 1 : -1), { idea: idea['idea'], categories: idea['categories'] }.to_json)
  end

  private
  def self.redis
    if ENV["REDISTOGO_URL"]
      uri = URI.parse(ENV["REDISTOGO_URL"])
      @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      @redis ||= Redis.new
    end
  end
end