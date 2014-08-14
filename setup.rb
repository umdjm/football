require 'rubygems'
require 'sequel'
require 'csv'
require 'mechanize'
require 'yaml'

CONFIG = YAML.load_file('league_settings.yml')
NFL_PROJECTIONS_URL = 'http://fantasy.nfl.com/research/projections'
ADP_URL = 'http://www.fantasypros.com/nfl/adp/overall.php'
BYE_URL = 'http://www.fantasypros.com/nfl/bye-weeks.php'
OFFENSIVE_CATEGORIES = %w(games pass_yards pass_touchdowns interceptions rush_yards rush_touchdowns reception_yards reception_touchdowns fumbles conversions)
POSITIONS = {'QB'  => {loops: 2,
                       categories: OFFENSIVE_CATEGORIES},
             'RB'  => {loops: 4,
                       categories: OFFENSIVE_CATEGORIES},
             'WR'  => {loops: 6,
                       categories: OFFENSIVE_CATEGORIES},
             'TE'  => {loops: 2,
                       categories: OFFENSIVE_CATEGORIES},
             'K'   => {loops: 2,
                       categories: %w(games pats 0-19 20-29 30-39 40-49 over_50)},
             'DEF' => {loops: 2,
                       categories: %w(games sacks defensive_interceptions defensive_fumble safeties defensive_touchdowns returns points_allowed)}}
TEAM_TO_ABBREV = { 'Buffalo Bills' => 'BUF',
                   'Miami Dolphins' => 'MIA',
                   'New England Patriots' => 'NE',
                   'New York Jets' => 'NYJ',
                   'Baltimore Ravens' => 'BAL',
                   'Cincinnati Bengals' => 'CIN',
                   'Cleveland Browns' => 'CLE',
                   'Pittsburgh Steelers' => 'PIT',
                   'Houston Texans' => 'HOU',
                   'Indianapolis Colts' => 'IND',
                   'Jacksonville Jaguars' => 'JAX',
                   'Tennessee Titans' => 'TEN',
                   'Denver Broncos' => 'DEN',
                   'Kansas City Chiefs' => 'KC',
                   'Oakland Raiders' => 'OAK',
                   'San Diego Chargers' => 'SD',
                   'Dallas Cowboys' => 'DAL',
                   'New York Giants' => 'NYG',
                   'Philadelphia Eagles' => 'PHI',
                   'Washington Redskins' => 'WAS',
                   'Chicago Bears' => 'CHI',
                   'Detroit Lions' => 'DET',
                   'Green Bay Packers' => 'GB',
                   'Minnesota Vikings' => 'MIN',
                   'Atlanta Falcons' => 'ATL',
                   'Carolina Panthers' => 'CAR',
                   'New Orleans Saints' => 'NO',
                   'Tampa Bay Buccaneers' => 'TB',
                   'Arizona Cardinals' => 'ARI',
                   'St. Louis Rams' => 'STL',
                   'San Francisco 49ers' => 'SF',
                   'Seattle Seahawks' => 'SEA'}

DB = if ENV['DATABASE_URL']
			 Sequel.connect(ENV['DATABASE_URL'])
		 else
			 Sequel.sqlite('football.sqlite')
		 end

puts "Creating players table"
DB.drop_table :players if DB.table_exists? :players

DB.create_table :players do
  primary_key :id 
  String :name
  String :team
  String :position
  String :games
  Decimal :pass_yards, default: 0
  Decimal :pass_touchdowns, default: 0
  Decimal :interceptions, default: 0
  Decimal :rush_yards, default: 0
  Decimal :rush_touchdowns, default: 0
  Decimal :reception_yards, default: 0
  Decimal :reception_touchdowns, default: 0
  Decimal :fumbles, default: 0
  Decimal :conversions, default: 0
  Decimal :adp, default: 0
  Decimal :value, default: 0
  Decimal :bye
  Decimal :points_allowed, default: 0
  Decimal :sacks, default: 0
  Decimal :safeties, default: 0
  Decimal :defensive_fumble, default: 0
  Decimal :returns, default: 0
  Decimal :defensive_interceptions, default: 0
  Decimal :defensive_touchdowns, default: 0
  Decimal :blocked_fgs, default: 0
  Decimal :pats, default: 0
  Decimal :"0-19", default: 0
  Decimal :"20-29", default: 0
  Decimal :"30-39", default: 0
  Decimal :"40-49", default: 0
  Decimal :over_50, default: 0
  TrueClass :drafted, :default => false
  TrueClass :mine, :default => false
  TrueClass :sleeper, :default => false
  TrueClass :injury, :default => false
  TrueClass :favorite, :default => false
  TrueClass :rookie, :default => false
  TrueClass :returner, :default => false
end

DB.add_index :players, :id 
DB.add_index :players, [:id, :position]

@players_table = DB[:players]
@agent = Mechanize.new

def calculate_points_allowed player
  avg_points = player[:points_allowed] / player[:games]
  CONFIG['scoring']['defense']['points_allowed'].each do |points, score|
    return score * player[:games] if avg_points <= points
  end
  0
end

def calculate_value player
  offensive_scoring = CONFIG['scoring']['offense']
  defensive_scoring = CONFIG['scoring']['defense']
  value = player[:pass_yards] * offensive_scoring['pass_yards'] +
    player[:pass_touchdowns] * offensive_scoring['pass_touchdowns'] +
    player[:interceptions] * offensive_scoring['interceptions'] +
    player[:rush_yards] * offensive_scoring['rush_yards'] +
    player[:rush_touchdowns] * offensive_scoring['rush_touchdowns'] +
    player[:reception_yards] * offensive_scoring['reception_yards'] +
    player[:reception_touchdowns] * offensive_scoring['reception_touchdowns'] +
    player[:conversions] * offensive_scoring['conversions'] +
    player[:fumbles] * offensive_scoring['fumbles'] +
    player[:"0-19"] * offensive_scoring['fg_19'] +
    player[:"20-29"] * offensive_scoring['fg_29'] +
    player[:"30-39"] * offensive_scoring['fg_39'] +
    player[:"40-49"] * offensive_scoring['fg_49'] +
    player[:over_50] * offensive_scoring['fg_100'] +
    player[:pats] * offensive_scoring['pat'] +
    player[:sacks] * defensive_scoring['sacks'] +
    player[:defensive_interceptions] * defensive_scoring['interceptions'] +
    player[:defensive_fumble] * defensive_scoring['fumbles'] +
    player[:safeties] * defensive_scoring['safeties'] +
    player[:defensive_touchdowns] * defensive_scoring['touchdowns']
  value = value + calculate_points_allowed(player) if player[:position] == 'DEF'
  value
end

projections = @agent.get NFL_PROJECTIONS_URL
puts 'getting projections'
POSITIONS.each do |position, settings|
  print "   #{position}...\r"
  pos = projections.link_with(text: position).click
  pos = pos.link_with(text: '2014 Season').click
  next_page = false
  settings[:loops].times do
    pos = pos.link_with(text: '>').click if next_page
    pos.at('.tableType-player').css('tbody tr').each do |player|
      name = player.css('td a').first.text
      tds = player.css('td')
      player = Hash.new{|h,k| h[k] = 0}
      settings[:categories].each_with_index do |category, index|
        player[category.to_sym] = tds[index + 2].text.to_i
      end
      name = tds.css('a').first.text.strip
      team = tds.css('em').first.text[-3,3]
      @players_table.insert(player.merge({name: name,
                                          team: team ? team.strip : nil,
                                          value: calculate_value(player),
                                          position: position}))
    end
    next_page = true
  end
end

puts 'getting adp'
adp = @agent.get(ADP_URL)
adp.at('table#data').css('tbody tr').each do |player|
  name = player.css('td')[1].text.gsub(/Defense/, '').gsub(/\(.*/, '').strip
  adp = player.css('td')[9].text.to_f
  @players_table.where(name: name).update(adp: adp)
end

puts 'fixing defensive teams'
TEAM_TO_ABBREV.each { |team, abbrev| @players_table.where(name: team).update(team: abbrev) }

puts 'inserting bye weeks'
byes = @agent.get(BYE_URL)
byes.at('table#data').css('tbody tr').each do |row|
  @players_table.where(team: TEAM_TO_ABBREV[row.css('td')[0].text.strip]).update(bye: row.css('td')[1].text.to_i)
end
