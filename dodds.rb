require 'rubygems'
require 'sequel'
require 'csv'
require './lib/offense'
require './lib/defense'
require './lib/kickers'

DB = Sequel.sqlite('football.sqlite')
DB[:offense].truncate
DB[:defense].truncate
DB[:kickers].truncate

puts 'Inserting QBs'
CSV.open('data/dodds/qb.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => "#{row['first']} #{row['last']}",
                      :team => row['team'],
                      :position => 'QB',
                      :completions => row['comp'],
                      :attempts => row['att'],
                      :pass_yards => row['passyards'],
                      :pass_touchdowns => row['passtd'],
                      :interceptions => row['int'],
                      :rushes => row['rushatt'],
                      :rush_yards => row['rushyds'],
                      :rush_touchdowns => row['rushtd'],
                      :fumbles => row['fumbles'],
                      :adp => row['adp']
end

puts 'Inserting RBs'
CSV.open('data/dodds/rb.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => "#{row['first']} #{row['last']}",
                      :team => row['team'],
                      :position => 'RB',
                      :rushes => row['rushatt'],
                      :rush_yards => row['rushyards'],
                      :rush_touchdowns => row['rushtd'],
                      :receptions => row['rec'],
                      :reception_yards => row['recyards'],
                      :reception_touchdowns => row['rectd'],
                      :fumbles => row['fumbles'],
                      :adp => row['adp']
end

puts 'Inserting WRs'
CSV.open('data/dodds/wr.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => "#{row['first']} #{row['last']}",
                      :team => row['team'],
                      :position => 'WR',
                      :rushes => row['rushatt'],
                      :rush_yards => row['rushyads'],
                      :rush_touchdowns => row['rushtd'],
                      :receptions => row['rec'],
                      :reception_yards => row['recyards'],
                      :reception_touchdowns => row['rectd'],
                      :fumbles => row['fumbles'],
                      :adp => row['adp']
end

puts 'Inserting TEs'
CSV.open('data/dodds/te.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:offense].insert :name => "#{row['first']} #{row['last']}",
                      :team => row['team'],
                      :position => 'TE',
                      :receptions => row['rec'],
                      :reception_yards => row['recyards'],
                      :reception_touchdowns => row['rectd'],
                      :fumbles => row['fumbles'],
                      :adp => row['adp']
end

puts 'Inserting Ks'
CSV.open('data/dodds/k.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:kickers].insert :name => "#{row['first']} #{row['last']}",
                      :team => row['team'],
                      :pats => row['patmade'],
                      :fg_made => row['fgmade'],
                      :fg_miss => row['fgmiss'],
                      :adp => row['adp']
end

puts 'Inserting DEF'
CSV.open('data/dodds/def.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:defense].insert :team => row['team'],
                      :points_allowed => row['allowed'],
                      :sacks => row['sacks'],
                      :safeties => row['safeties'],
                      :interceptions => row['interceptions'],
                      :fumbles => row['fumbles'],
                      :touchdowns => row['tds'],
                      :adp => row['adp']
end

puts 'Calculating Values'
DB[:offense].all { |p| DB[:offense].filter(:id => p[:id]).update(:value => Offense.expected_points(p)) }
DB[:defense].all { |p| DB[:defense].filter(:id => p[:id]).update(:value => Defense.expected_points(p)) }
DB[:kickers].all { |p| DB[:kickers].filter(:id => p[:id]).update(:value => Kickers.expected_points(p)) }
