require "./../game_mod"
require "./generate_encounter"

module Obscura
  class GenerateMissions
    def initialize(@game : Obscura::Game)
    end
    def run!
      1.upto(10) do |i|
        mission = Obscura::Mission.new
        mission.name = Obscura::GameMod.random_mission_name
        mission.difficulty = i
        mission.reputation_bonus = mission.difficulty * 10
        mission.encounter = Obscura::GenerateEncounter.new(@game.mod, mission.difficulty).run!
        @game.missions.push mission
      end
    end
  end
end
