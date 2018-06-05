module Obscura
  class Game
    INITIAL_REPUTATION = 0
    MAXIMUM_REPUTATION = 100

    INITIAL_PLAYER_LEVEL = 1

    property :reputation
    property :player_level
    property :missions
    @current_mission : Obscura::Mission | Nil
    property :current_mission

    def initialize
      @reputation = INITIAL_REPUTATION
      @player_level = INITIAL_PLAYER_LEVEL
      @missions = Array(Obscura::Mission).new
      @current_mission = nil
    end

    def won?
      @reputation >= MAXIMUM_REPUTATION
    end
  end
end
