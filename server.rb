require 'sinatra'
require 'thin'
require './lib/offense'
require './lib/defense'
require './lib/kickers'

set(:css_dir) { File.join(views, 'css') }

get '/' do
  @players = Calculate.all(params)
  erb :index
end

get '/reset' do
  Calculate.reset
  redirect to('/')
end

get '/:table' do
  @players = Calculate.players(params[:table], params)
  erb :index
end

post '/:table/draft' do
  Calculate.draft params[:table].to_sym, params[:player_id] 
  redirect to('/')
end
