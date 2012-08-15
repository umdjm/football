require 'rubygems'
require 'sequel'
require 'yaml'

module Calculate
  DB = Sequel.sqlite('football.sqlite')
  CONFIG = YAML.load_file('league_settings.yml')

  class Offense
    class << self
      def players opts = {}
        query = DB[:offense]
        query = query.filter(:position => opts['position'].upcase) if opts['position'] && !opts['position'].empty?
        query = opts['limit'] && !opts['limit'].empty? ? query.limit(opts['limit']) : query.limit(500)
        query = query.filter(:drafted => false) if opts['hide-drafted']
        all = query.all
        all.each{|p| p[:value] = expected_points(p)}
        all.sort_by{|p| p[:value]}.reverse
      end 

      def draft player_id
        puts "drafting #{player_id} from #{table} table"
        DB[:offense].filter(:id => player_id).update(:drafted => true)
      end 

      private
      def expected_points player
        [:completions, :pass_yards, :pass_touchdowns, :interceptions,
         :rush_yards, :rush_touchdowns,
         :receptions, :reception_yards, :reception_touchdowns,
         :conversions, :fumbles].inject(0) do |acc, attr|
          acc + CONFIG['offense'][attr.to_s] * (player[attr] || 0)
        end
      end
    end
  end

  class Defense
  end

  class Kicker
  end
end
