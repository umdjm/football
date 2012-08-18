require 'rubygems'
require 'sequel'

DB = Sequel.sqlite('football.sqlite')

puts "Creating tables"
DB.drop_table :offense if DB.table_exists? :offense
DB.drop_table :defense if DB.table_exists? :defense
DB.drop_table :kickers if DB.table_exists? :kickers

DB.create_table :offense do
  primary_key :id 
  String :name
  String :team
  String :position
  Decimal :games
  Decimal :completions
  Decimal :attempts 
  Decimal :pass_yards
  Decimal :pass_touchdowns 
  Decimal :interceptions
  Decimal :rushes
  Decimal :rush_yards
  Decimal :rush_touchdowns
  Decimal :receptions
  Decimal :reception_yards
  Decimal :reception_touchdowns
  Decimal :fumbles
  Decimal :adp
  Decimal :value
  TrueClass :drafted, :default => false
  TrueClass :sleeper, :default => false
  TrueClass :injury, :default => false
  TrueClass :favorite, :default => false
end

DB.create_table :defense do
  primary_key :id 
  String :team
  String :name
  String :position, :default => 'DEF'
  Decimal :points_allowed
  Decimal :sacks
  Decimal :safeties 
  Decimal :interceptions
  Decimal :fumbles 
  Decimal :touchdowns
  Decimal :blocked_fgs
  Decimal :adp
  Decimal :value
  TrueClass :drafted, :default => false
  TrueClass :sleeper, :default => false
  TrueClass :injury, :default => false
  TrueClass :favorite, :default => false
end

DB.create_table :kickers do
  primary_key :id 
  String :name
  String :team
  String :position, :default => 'K'
  Decimal :pats
  Decimal :fg_made
  Decimal :fg_miss
  Decimal :"0-19"
  Decimal :"20-29"
  Decimal :"30-39"
  Decimal :"40-49"
  Decimal :over_50
  Decimal :adp
  Decimal :value
  TrueClass :drafted, :default => false
  TrueClass :sleeper, :default => false
  TrueClass :injury, :default => false
  TrueClass :favorite, :default => false
end

DB.add_index :offense, :id 
DB.add_index :offense, [:id, :position]
DB.add_index :defense, :id 
DB.add_index :kickers, :id 
