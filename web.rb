require'sinatra'
require "./lib/database"
Dir["#{File.join(File.dirname(__FILE__), "lib", "models")}/*.rb"].each {|file| require file}
set :views, Proc.new { File.join(root, "lib", "views") }

helpers do
  include Rack::Utils
  alias_method :h, :escape
end

# Routes
get '/' do
  @good_ideas = Idea.good
  @bad_ideas = Idea.bad
  erb :index
end

post '/' do
  @idea = Idea.new(params[:idea], params[:categories])
  params[:direction] == 'up' ? @idea.upvote : @idea.downvote
  redirect request.referrer
end

get '/random' do
  @idea = Idea.new
  erb :random
end

get '/categories' do
  @categories = Categories.all
  erb :categories
end

post '/categories' do
  Categories.add(params[:category])
  redirect request.referrer
end

delete '/categories/:id' do
  Categories.remove(params[:id])
  redirect request.referrer
end