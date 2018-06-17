require "./../fighter"
require "./../weapon"

module Obscura
  class GeneratePlayers
    def initialize(@weapons : Array(Obscura::Weapon))
    end

    def run!() Array(Obscura::Fighter)
      players = Array(Obscura::Fighter).new
      4.times do |i|
        player = Obscura::Fighter.new
        player.name = "Player #{i + 1}"
        player.precision = 75
        player.weapon = @weapons.sample
        player.hit_points = 100
        players << player
      end
      players
    end
  end
end
