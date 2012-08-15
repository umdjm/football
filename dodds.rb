require 'rubygems'
require 'sequel'
require 'csv'

DB = Sequel.sqlite('football.sqlite')
DB[:offense].truncate
DB[:defense].truncate
DB[:kickers].truncate

puts 'Inserting QBs'
CSV.open('dodds/qb.csv', {:headers => true, :header_converters => :downcase}).each do |row|
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
CSV.open('dodds/rb.csv', {:headers => true, :header_converters => :downcase}).each do |row|
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
CSV.open('dodds/wr.csv', {:headers => true, :header_converters => :downcase}).each do |row|
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
CSV.open('dodds/te.csv', {:headers => true, :header_converters => :downcase}).each do |row|
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
CSV.open('dodds/k.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:kickers].insert :name => "#{row['first']} #{row['last']}",
                      :team => row['team'],
                      :pats => row['patmade'],
                      :fg_made => row['fgmade'],
                      :fg_miss => row['fgmiss'],
                      :adp => row['adp']
end

puts 'Inserting DEF'
CSV.open('dodds/def.csv', {:headers => true, :header_converters => :downcase}).each do |row|
  DB[:defense].insert :team => row['team'],
                      :points_allowed => row['allowed'],
                      :sacks => row['sacks'],
                      :safeties => row['safeties'],
                      :interceptions => row['interceptions'],
                      :fumbles => row['fumbles'],
                      :touchdowns => row['tds'],
                      :adp => row['adp']
end
