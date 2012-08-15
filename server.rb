require 'sinatra'
require 'thin'
require './lib/offense'
require './lib/defense'
require './lib/kickers'

set(:css_dir) { File.join(views, 'css') }

get '/' do
  @players = Calculate.players(:offense, params) + Calculate.players(:defense, params) + Calculate.players(:kickers, params)
  erb :index
end

post '/draft' do
  Offense.draft params[:player_id] 
  redirect to('/')
end
