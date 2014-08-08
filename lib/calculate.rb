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
      query = query.filter(:drafted => 0) if opts['hide-drafted'] # TODO why do bools not work
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
  end
end
