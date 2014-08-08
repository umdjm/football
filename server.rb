require './lib/calculate'
require './lib/recommend.rb'

class Football < Sinatra::Base
  set(:css_dir) { File.join(views, 'css') }

  get '/' do
    @players = Calculate.players(params)
    @team = Calculate.players({'mine' => true})
    erb :index
  end

  get '/reset' do
    Calculate.reset
    redirect to('/')
  end

  get '/recommend' do
    players = Calculate.players({'hide-drafted' => true}).sort_by{|p| p[:adp]}
    team = Recommend.generate_team players, Calculate.requirements, 40, 20
    JSON.generate team
  end

  post '/draft' do
    Calculate.draft params[:player_id] 
    redirect "/?position=#{params[:position]}&limit=#{params[:limit]}&#{params[:"hide-drafted"] ? 'hide-drafted=' : ''}"
  end

  post '/take' do
    Calculate.take params[:player_id]
    redirect "/?position=#{params[:position]}&limit=#{params[:limit]}"
  end
end
