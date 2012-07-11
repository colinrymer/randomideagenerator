%w( json nokogiri open-uri redis sinatra ).each {|lib| require lib}

CATEGORIES = %w(National_Toy_Hall_of_Fame_inductees Technology Packaging Animals_described_in_1758 Simple_machines Weapons American_cuisine Traditional_Chinese_objects String_instruments Creativity American_inventions)

class RandomPage
  def initialize(pool)
      @pool = pool
      doc
  end

  def doc
    @doc ||= Nokogiri::HTML(open("http://en.wikipedia.org/wiki/Category:#{@pool.sample}"))
  end

  def title
    @title ||= doc.css('#mw-pages ul li a').map{|a| a["title"]}.sample.downcase
  end

  def category
    @category ||= @doc.css('title').children.first.content.split(' - Wikipedia, the free encyclopedia').first.split('Category:').last
  end
end

class IdeaGenerator
  def initialize(categories)
    @first = RandomPage.new(categories)
    @second = RandomPage.new(categories)
  end

  def idea
    "#{@first.title} #{@second.title}"
  end

  def categories
    "#{@first.category} | #{@second.category}"
  end
end

uri = URI.parse(ENV["REDISTOGO_URL"])
redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

# Routes
get '/' do
  @ideas = redis.zrevrangebyscore(:ideas, '+inf', '-inf', withscores: true).map{|idea| { idea: JSON.parse(idea.first)['idea'], categories: JSON.parse(idea.first)['categories'], score: idea.last } }
  erb :index
end

post '/' do
  redis.zincrby(:ideas, (params['vote'] == 'up' ? 1 : -1), { idea: params['idea'], categories: params['categories'] }.to_json)
  @ideas = redis.zrevrangebyscore(:ideas, '+inf', '-inf', withscores: true).map{|idea| { idea: JSON.parse(idea.first)['idea'], categories: JSON.parse(idea.first)['categories'], score: idea.last } }
  erb :index
end

get '/random' do
  @idea = IdeaGenerator.new(CATEGORIES)
  erb :random
end

post '/random' do
  redis.zincrby(:ideas, 1, { idea: params['idea'], categories: params['categories'] }.to_json)
  @idea = IdeaGenerator.new(CATEGORIES)
  erb :random
end