module Obscura
  class GenerateMissions
    def initialize(game : Obscura::Game)
      @game = game
    end
    def run!
      10.times do
        mission = Obscura::Mission.new
        mission.difficulty = (Random.rand(10) + 1) * 10
        @game.missions.push mission
      end
    end
  end
end
