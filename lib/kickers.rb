require './lib/calculate'

class Kickers
  include Calculate

  def self.expected_points player
    total = [:fg_made, :fg_miss, :pats].inject(0) do |acc, attr|
      acc + Calculate::CONFIG['kickers'][attr.to_s] * (player[attr] || 0)
    end
  end
end
