require 'rubygems'
require 'sequel'
require 'yaml'

module Calculate
  DB = Sequel.sqlite('football.sqlite')
  CONFIG = YAML.load_file('league_settings.yml')

  class << self
    def all opts = {}
      players(:offense, opts) + players(:defense, opts) + players(:kickers, opts)
    end

    def reset
      [:offense, :defense, :kickers].each do |table|
        Calculate::DB[table].update(:drafted => false)
      end
    end

    def players table, opts = {}
      query = Calculate::DB[table]
      query = query.filter(:position => opts['position'].upcase) if opts['position'] && !opts['position'].empty?
      query = opts['limit'] && !opts['limit'].empty? ? query.limit(opts['limit']) : query.limit(500)
      query = query.filter(:drafted => false) if opts['hide-drafted']
      all = query.all
      all.each do |p|
        p[:table] = table
        p[:value] = Object.const_get(table.capitalize).expected_points(p)
      end
    end

    def draft table, player_id
      Calculate::DB[table].filter(:id => player_id).update(:drafted => true)
    end
  end
end
