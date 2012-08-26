require 'ai4r'
require 'sequel'
require 'yaml'
require './lib/calculate'
require './lib/recommend'

Recommend.generate_team Calculate.players.sort_by{|p| p[:adp]}, CONFIG['requirements'], 1000, 500
