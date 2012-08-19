require 'sequel'
require 'csv'
require 'yaml'
require './lib/offense'

DB = Sequel.sqlite('football.sqlite')
DB[:offense].truncate

puts 'Inserting QBs'
CSV.open('data/fantasypros/qb.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => row['playername'],
                      :team => row['team'],
                      :position => 'QB',
                      :completions => row['pass_cmp'],
                      :attempts => row['pass_att'],
                      :pass_yards => row['pass_yds'],
                      :pass_touchdowns => row['pass_tds'],
                      :interceptions => row['pass_ints'],
                      :rushes => row['rush_att'],
                      :rush_yards => row['rush_yds'],
                      :rush_touchdowns => row['rush_tds'],
                      :fumbles => row['fumbles']
end

puts 'Inserting RBs'
CSV.open('data/fantasypros/rb.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => row['playername'],
                      :team => row['team'],
                      :position => 'RB',
                      :rushes => row['rush_att'],
                      :rush_yards => row['rush_yds'],
                      :rush_touchdowns => row['rush_tds'],
                      :receptions => row['rec_att'],
                      :reception_yards => row['rec_yds'],
                      :reception_touchdowns => row['rec_tds'],
                      :fumbles => row['fumbles'],
                      :adp => row['adp']
end

puts 'Inserting WRs'
CSV.open('data/fantasypros/wr.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => row['playername'],
                      :team => row['team'],
                      :position => 'WR',
                      :receptions => row['rec_att'],
                      :reception_yards => row['rec_yds'],
                      :reception_touchdowns => row['rec_tds'],
                      :fumbles => row['fumbles'],
                      :adp => row['adp']
end

puts 'Inserting TEs'
CSV.open('data/fantasypros/te.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => row['playername'],
                      :team => row['team'],
                      :position => 'TE',
                      :receptions => row['rec_att'],
                      :reception_yards => row['rec_yds'],
                      :reception_touchdowns => row['rec_tds'],
                      :fumbles => row['fumbles'],
                      :adp => row['adp']
end

puts "Inserting ADPs"
CSV.open('data/fantasypros/adp.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].filter(:name => row['playername']).update(:adp => row['adp'])
end
DB[:offense].filter(:adp => nil).delete

puts 'Calculating Values'
DB[:offense].all { |p| DB[:offense].filter(:id => p[:id]).update(:value => Offense.expected_points(p)) }
