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

    def self.random_mission_name() String
      if Random.rand(2) == 0
        [MISSION_NAME_TYPES.sample, MISSION_NAME_SUFFIX.sample].join(" ")
      else
        [MISSION_NAME_PREFIX.sample, MISSION_NAME_TYPES.sample].join(" ")
      end
    end
  end
end
