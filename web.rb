%w( json nokogiri open-uri redis sinatra ).each {|lib| require lib}
%w( categories randompage ideagenerator ).each {|lib| require "./lib/#{lib}" }

def redis
  if ENV["REDISTOGO_URL"]
    uri = URI.parse(ENV["REDISTOGO_URL"])
    @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  else
    @redis ||= Redis.new
  end
end

def new_idea
  IdeaGenerator.new(CATEGORIES)
end

def ideas(min, max)
  redis.zrevrangebyscore(:ideas, max, min, withscores: true).map{|idea| { idea: JSON.parse(idea.first)['idea'], categories: JSON.parse(idea.first)['categories'], score: idea.last } }
end

def bad_ideas
  ideas '-inf', '0'
end

def good_ideas
  ideas '1', '+inf'
end

def update_idea(idea_hash)
  redis.zincrby(:ideas, (idea_hash['direction'] == 'up' ? 1 : -1), { idea: idea_hash['idea'], categories: idea_hash['categories'] }.to_json)
end


# Routes
get '/' do
  @ideas = good_ideas
  erb :index
end

get '/random' do
  @idea = new_idea
  erb :random
end

get '/rejects' do
  @ideas = bad_ideas
  erb :index
end

post '/' do
  update_idea(params)
  redirect request.referrer
end