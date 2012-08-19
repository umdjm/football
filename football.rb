require './lib/offense'
require './lib/defense'
require './lib/kickers'
require './lib/recommend.rb'

class Football < Sinatra::Base
  set(:css_dir) { File.join(views, 'css') }

  get '/' do
    @players = Calculate.all(params)
    @team = Calculate.all({'mine' => true})
    erb :index
  end

  get '/reset' do
    Calculate.reset
    redirect to('/')
  end

  get '/recommend' do
    players = Calculate.all({'hide-drafted' => true}).sort_by{|p| p[:adp]}
    team = Recommend.generate_team players, Calculate.requirements
    JSON.generate team
  end

  post '/:table/draft' do
    Calculate.draft params[:table].to_sym, params[:player_id] 
    redirect "/?position=#{params[:position]}&limit=#{params[:limit]}"
  end

  post '/:table/take' do
    Calculate.take params[:table].to_sym, params[:player_id]
    redirect "/?position=#{params[:position]}&limit=#{params[:limit]}"
  end
end
