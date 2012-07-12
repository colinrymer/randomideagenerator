require'sinatra'
require './lib/ideas'

# Routes
get '/' do
  @ideas = Ideas.good
  erb :index
end

get '/random' do
  @idea = Ideas.create
  erb :random
end

get '/rejects' do
  @ideas = Ideas.bad
  erb :index
end

post '/' do
  Ideas.update params
  redirect request.referrer
end