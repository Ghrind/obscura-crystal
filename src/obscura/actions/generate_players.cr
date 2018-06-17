require "./../fighter"
require "./../game_mod"

module Obscura
  class GeneratePlayers
    NAMES = [
      "Sarge",
      "Warhead",
      "Nail",
      "Meat Popsicle",
    ]

    WEAPONS = [
      "Assault rifle",
      "Shotgun",
      "Sniper rifle",
      "Machinegun",
    ]

    
    def initialize(@mod : Obscura::GameMod)
    end

    def run!() Array(Obscura::Fighter)
      players = Array(Obscura::Fighter).new
      4.times do |i|
        player = init_player
        player.name = NAMES[i]
        player.weapon = @mod.find_weapon(WEAPONS[i])
        players << player
      end
      players
    end

    private def init_player
      player = Obscura::Fighter.new
      player.precision = 75
      player.hit_points = 100
      player
    end
  end
end
