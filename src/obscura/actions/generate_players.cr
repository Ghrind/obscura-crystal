require "./../fighter"

module Obscura
  class GeneratePlayers
    def run!() Array(Obscura::Fighter)
      players = Array(Obscura::Fighter).new
      4.times do |i|
        player = Obscura::Fighter.new
        player.name = "Player #{i + 1}"
        weapon = Obscura::Weapon.new
        weapon.name = "Pistol"
        weapon.modes = ["single-shot", "burst", "precision-shot", "suppressive-fire"]
        weapon.damage_min = 3
        weapon.damage_max = 9
        weapon.precision = 0
        weapon.precision_bonus = 10
        weapon.hits_per_turn = 2
        player.precision = 75
        player.weapon = weapon
        player.hit_points = 100
        players << player
      end
      players
    end
  end
end
