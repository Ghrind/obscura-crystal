module Obscura
  class CancelCurrentMission
    def initialize(@game : Obscura::Game)
    end

    def run!
      @game.current_mission = nil
    end
  end
end
