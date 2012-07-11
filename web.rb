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

def get_ideas
  redis.zrevrangebyscore(:ideas, '+inf', '-inf', withscores: true).map{|idea| { idea: JSON.parse(idea.first)['idea'], categories: JSON.parse(idea.first)['categories'], score: idea.last } }
end

def update_idea(amount, idea_hash)
  redis.zincrby(:ideas, amount, { idea: idea_hash['idea'], categories: idea_hash['categories'] }.to_json)
end

# Routes
get '/' do
  @ideas = get_ideas
  erb :index
end

post '/' do
  update_idea((params['vote'] == 'up' ? 1 : -1), params)
  @ideas = get_ideas
  erb :index
end

get '/random' do
  @idea = new_idea
  erb :random
end

post '/random' do
  update_idea(1, params)
  @idea = new_idea
  erb :random
end