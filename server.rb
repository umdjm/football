require 'sinatra'
require 'thin'
require './calculate'

set(:css_dir) { File.join(views, 'css') }

get '/' do
  @players = Calculate::Offense.players params
  erb :index
end

post '/draft' do
  Calculate::Offense.draft params[:player_id] 
  redirect to('/')
end
