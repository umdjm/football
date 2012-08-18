require 'rubygems'
require 'ai4r'
require 'sequel'
require 'yaml'
require './lib/calculate'

module Recommend
  CONFIG = YAML.load_file('league_settings.yml')

  module Ai4r::GeneticAlgorithm
    class Chromosome
      attr_reader :team, :id

      class << self
        def set_requirements players, requirements
          @@players      = players
          @@requirements = requirements
          @@rounds       = requirements.size
          @@id           = 0
        end

        def seed
          team = []
          requirements = @@requirements.shuffle
          players = @@players.dup
          @@rounds.times do |round|
            player = players.dup.keep_if{|p| p[:position] == requirements.first || 'FLEX' == requirements.first}.sort_by{|p| p[:value]}.reverse.first
            team << player
            players.delete player
            players = players[9..-1]
            requirements = requirements[1..-1]
          end
          c = Chromosome.new team
          #puts "Seed #{c.id}:"
          #team.each_with_index{|p, i| puts "#{i}: #{p[:adp].to_i}. #{p[:name]} #{p[:team]} #{p[:position]}"}
          #puts "============"
          c
        end

        def mutate chromosome
          rounds = [rand(@@rounds), rand(@@rounds)]
          player1, player2 = chromosome.team[rounds.first], chromosome.team[rounds.last]
          players = @@players.dup
          players.delete_if{|p| chromosome.team.include?(p)}
          new_player1 = players.dup.sort_by{|p| p[:adp]}[(10 * rounds.first)..-1].keep_if{|p| p[:position] == player2[:position]}.sort_by{|p| p[:value]}.reverse.first
          players.delete(new_player1)
          new_player2 = players.dup.sort_by{|p| p[:adp]}[(10 * rounds.last)..-1].keep_if{|p| p[:position] == player1[:position]}.sort_by{|p| p[:value]}.reverse.first
          #puts "Mutate #{chromosome.id}:"
          #puts "Swapping in #{new_player1[:adp].to_i}. #{new_player1[:name]} #{new_player1[:team]} #{new_player1[:position]} at #{rounds.first}"
          #puts "Swapping in #{new_player2[:adp].to_i}. #{new_player2[:name]} #{new_player2[:team]} #{new_player2[:position]} at #{rounds.last}"
          #puts "============"
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
              player = players.dup.keep_if{|p| p[:position] == requirements.first || 'FLEX' == requirements.first}.sort_by{|p| p[:value]}.reverse.first
              team[round] = player
              players.delete player
              players = players[9..-1]
              requirements = requirements[1..-1]
            else
              players = players[10..-1]
            end
          end

          c = Chromosome.new team
          #puts "Reproduce #{a.id} + #{b.id} = #{c.id}:"
          #team.each_with_index{|p, i| puts "#{i}: #{p[:adp].to_i}. #{p[:name]} #{p[:team]} #{p[:position]}"}
          #puts "============"
          c
        end
      end

      def initialize team
        @team = team
        @id   = @@id
        @@id  += 1
      end

      def fitness
        return team.inject(0){|acc, p| acc + p[:value]}
      end

      def swap index, new_player
        @team[index] = new_player
      end
    end
  end

  def self.generate_team
    Ai4r::GeneticAlgorithm::Chromosome.set_requirements Calculate.all.sort_by{|p| p[:adp]}, CONFIG['requirements']
    result = Ai4r::GeneticAlgorithm::GeneticSearch.new(80, 30).run
    puts "Team:"
    result.team.each {|player| puts " #{player[:adp].to_i}. #{player[:name]} #{player[:team]} (#{player[:position]})" }
    puts "Total points: #{result.fitness.to_f}"
  end
end

Recommend.generate_team
