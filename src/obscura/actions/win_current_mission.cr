require "./../mission_result"

module Obscura
  class WinCurrentMission
    def initialize(@game : Obscura::Game)
    end

    def run!
      mission = @game.current_mission.not_nil!
      mission.completed = true
      @game.reputation += mission.reputation_bonus
      @game.current_mission = nil
      MissionResult.new(mission.name)
    end
  end
end
