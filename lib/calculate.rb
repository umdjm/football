module Calculate
  DB = Sequel.sqlite('football.sqlite')
  CONFIG = YAML.load_file('league_settings.yml')

  class << self
    def reset
      Calculate::DB[:players].update(:drafted => false)
    end

    def players opts = {}
      query = Calculate::DB[:players].order(:value).reverse
      query = query.filter(:position => opts['position'].upcase) if opts['position'] && !opts['position'].empty?
      query = opts['limit'] && !opts['limit'].empty? ? query.limit(opts['limit']) : query.limit(500)
      query = query.filter(:mine => true) if opts['mine']
      query = query.filter(:drafted => false) if opts['hide-drafted']
      query.all
    end

    def draft player_id
      Calculate::DB[:players].filter(:id => player_id).update(:drafted => true)
    end

    def take player_id
      Calculate::DB[:players].filter(:id => player_id).update(:mine => true, :drafted => true)
    end

    def requirements
      mine = []
      requirements = CONFIG['requirements']
      mine += Calculate::DB[:players].filter(:mine => true).map{|p| p[:position]}
      mine.each { |taken| requirements.delete_at(requirements.index(taken) || requirements.index('FLEX')) }
      requirements
    end

    def expected_points player
      [:completions, :pass_yards, :pass_touchdowns, :interceptions,
       :rush_yards, :rush_touchdowns,
       :receptions, :reception_yards, :reception_touchdowns,
       :conversions, :fumbles,
       :sacks, :interceptions, :fumbles, :touchdowns, :safeties, :blocked_fgs,
       :fg_made, :fg_miss, :pats].inject(0) do |acc, attr|
        acc + (player[attr] ? Calculate::CONFIG['scoring'][attr.to_s] * (player[attr] || 0) : 0)
      end
    end
  end
end
