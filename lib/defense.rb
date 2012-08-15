require './lib/calculate'

class Defense
  include Calculate

  def self.expected_points player
    total = [:sacks, :interceptions, :fumbles, :touchdowns, :safeties, :blocked_fgs].inject(0) do |acc, attr|
      acc + Calculate::CONFIG['defense'][attr.to_s] * (player[attr] || 0)
    end
    total + points_allowed(player)
  end

  private
  def self.points_allowed player
    return 0 unless player['points_allowed']
    Calculate::CONFIG['defense']['points_allowed'][(player['points_allowed'] / 16).to_i] * 16
  end
end

