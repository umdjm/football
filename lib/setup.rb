require 'sequel'

desc "setup the database"
task :setup do
  DB = Sequel.sqlite('football.sqlite')

  puts "Creating players table"
  DB.drop_table :players if DB.table_exists? :players

  DB.create_table :players do
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
    Decimal :bye
    Decimal :points_allowed
    Decimal :sacks
    Decimal :safeties 
    Decimal :defensive_fumble
    Decimal :defensive_interceptions
    Decimal :defensive_touchdowns
    Decimal :blocked_fgs
    Decimal :pats
    Decimal :fg_made
    Decimal :fg_miss
    Decimal :"0-19"
    Decimal :"20-29"
    Decimal :"30-39"
    Decimal :"40-49"
    Decimal :over_50
    TrueClass :drafted, :default => false
    TrueClass :mine, :default => false
    TrueClass :sleeper, :default => false
    TrueClass :injury, :default => false
    TrueClass :favorite, :default => false
    TrueClass :rookie, :default => false
  end

  DB.add_index :players, :id 
  DB.add_index :players, [:id, :position]
end
