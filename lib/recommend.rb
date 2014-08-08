module Recommend
  module Ai4r::GeneticAlgorithm
    class Chromosome
      attr_reader :team

      class << self
        def set_requirements players, requirements
          @@players      = players
          @@requirements = requirements
          @@rounds       = requirements.size
        end

        def seed
          team = []
          requirements = @@requirements.shuffle
          players = @@players.dup
          @@rounds.times do |round|
            player = players.dup.keep_if{|p| p[:position] == requirements.first || flex?(p, requirements.first)}.sort_by{|p| p[:value]}.reverse.first
            team << player
            players.delete player
            players = players[9..-1]
            requirements = requirements[1..-1]
          end
          Chromosome.new team
        end

        def mutate chromosome
          rounds = [rand(@@rounds), rand(@@rounds)]
          player1, player2 = chromosome.team[rounds.first], chromosome.team[rounds.last]
          players = @@players.dup
          players.delete_if{|p| chromosome.team.include?(p)}
          new_player1 = players[(10 * rounds.first)..-1].find{|p| p[:position] == player2[:position]}
          players.delete(new_player1)
          new_player2 = players[(10 * rounds.last)..-1].find{|p| p[:position] == player1[:position]}
          old_fitness = chromosome.fitness
          old1 = chromosome.swap rounds.first, new_player1
          old2 = chromosome.swap rounds.last, new_player2
          if chromosome.fitness < old_fitness
            chromosome.swap rounds.first, old1
            chromosome.swap rounds.last, old2
          end
        end

        def reproduce a, b
          requirements = @@requirements.dup
          team = []
          @@rounds.times do |round|
            if a.team[round] == b.team[round]
              team[round] = a.team[round]
              requirements.delete_at(requirements.index(a.team[round][:position]) || requirements.index('FLEX'))
            end
          end

          players = @@players.dup.delete_if{|p| team.include?(p)}
          requirements.shuffle!
          @@rounds.times do |round|
            if team[round].nil?
              player = players.dup.keep_if{|p| p[:position] == requirements.first || flex?(p, requirements.first)}.sort_by{|p| p[:value]}.reverse.first
              team[round] = player
              players.delete player
              players = players[9..-1]
              requirements = requirements[1..-1]
            else
              players = players[10..-1]
            end
          end

          Chromosome.new team
        end

        def flex? player, position
          position == 'FLEX' && (player[:position] == 'WR' || player[:position] == 'RB')
        end
      end

      def initialize team
        @team = team
      end

      def fitness
        team.inject(0){|acc, p| acc + p[:value]}
      end

      def swap index, new_player
        @team[index] = new_player
      end
    end
  end

  def self.generate_team players, requirements, seeds, generations
    puts "Requirements: #{requirements}"
    Ai4r::GeneticAlgorithm::Chromosome.set_requirements players, requirements
    result = Ai4r::GeneticAlgorithm::GeneticSearch.new(seeds, generations).run
    puts "Team:"
    result.team.each {|player| puts " #{player[:adp].to_i}. #{player[:name]} #{player[:team]} (#{player[:position]})" }
    puts "Total points: #{result.fitness.to_f}"
    result.team
  end
end
