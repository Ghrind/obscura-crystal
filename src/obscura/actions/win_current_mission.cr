module Obscura
  class WinCurrentMission
    def initialize(@game : Obscura::Game)
    end

    def run!
      mission = @game.current_mission.not_nil!
      mission.completed = true
      @game.reputation += mission.difficulty
      @game.player_level += 1
      @game.current_mission = nil
    end
  end
end
