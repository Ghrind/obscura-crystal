require "./../game_mod"
require "./generate_encounter"

module Obscura
  class GenerateMissions
    def initialize(@game : Obscura::Game)
    end
    def run!
      10.times do
        mission = Obscura::Mission.new
        mission.name = Obscura::GameMod.random_mission_name
        mission.difficulty = (Random.rand(10) + 1) * 10
        mission.encounter = Obscura::GenerateEncounter.new.run!
        @game.missions.push mission
      end
    end
  end
end
