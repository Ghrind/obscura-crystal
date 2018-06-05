module Obscura
  class StartMission
    def initialize(game : Obscura::Game, mission_index : Int32)
      @game = game
      @mission_index = mission_index
    end

    def run!() Bool
      return false if @game.current_mission

      mission = @game.missions[@mission_index]

      return false if mission.completed

      @game.current_mission = mission
      true
    end
  end
end
