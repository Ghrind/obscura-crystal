module Obscura
  class TryMission
    def initialize(game : Game, mission : Mission)
      @game = game
      @mission = mission
    end

    def run!() MissionResult
      return MissionResult.new(:already_completed) if @mission.completed
      roll = Random.rand(100) + 1 + @game.player_level * 5
      if roll >= @mission.difficulty
        @game.reputation += @mission.difficulty
        @game.player_level += 1
        @mission.completed = true
        return MissionResult.new(:success, roll)
      else
        return MissionResult.new(:failure, roll)
      end
    end
  end
end
