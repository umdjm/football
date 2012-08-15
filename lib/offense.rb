require './lib/calculate'

class Offense
  include Calculate

  def self.expected_points player
    [:completions, :pass_yards, :pass_touchdowns, :interceptions,
     :rush_yards, :rush_touchdowns,
     :receptions, :reception_yards, :reception_touchdowns,
     :conversions, :fumbles].inject(0) do |acc, attr|
      acc + Calculate::CONFIG['offense'][attr.to_s] * (player[attr] || 0)
    end
  end
end

