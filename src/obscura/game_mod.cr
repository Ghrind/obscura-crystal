require "./mission"

module Obscura
  class GameMod
    MISSION_NAME_TYPES = [
      "Caverns",
      "Vault",
      "Ruins",
      "Lands",
      "Labyrinth",
      "Depth",
      "Bunker",
      "Waste",
      "Mine",
    ]

    MISSION_NAME_SUFFIX = [
      "of Anguish",
      "of Brandmoor",
      "of Rust",
      "of Newhome",
      "of Dorn",
    ]

    MISSION_NAME_PREFIX = [
      "Abandoned",
      "Forgotten",
      "Fathomless",
      "Arid",
      "Hidden",
    ]

    @weapons = Array(Obscura::Weapon).new
    property :weapons

    @fighters = Array(Obscura::Fighter).new
    property :fighters

    def self.random_mission_name() String
      if Random.rand(2) == 0
        [MISSION_NAME_TYPES.sample, MISSION_NAME_SUFFIX.sample].join(" ")
      else
        [MISSION_NAME_PREFIX.sample, MISSION_NAME_TYPES.sample].join(" ")
      end
    end

    def find_weapon(weapon_name) Obscura::Weapon
      weapon = @weapons.find { |w| w.name == weapon_name }
      return weapon if weapon
      Obscura::Weapon.new
    end

    def random_ennemy() Obscura::Fighter
      @fighters.sample
    end
  end
end
