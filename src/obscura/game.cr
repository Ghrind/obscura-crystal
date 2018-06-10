require "./mission"
require "./combat"

module Obscura
  class Game
    INITIAL_REPUTATION = 0
    MAXIMUM_REPUTATION = 100

    INITIAL_PLAYER_LEVEL = 1

    @reputation = INITIAL_REPUTATION
    property :reputation

    @player_level = INITIAL_PLAYER_LEVEL
    property :player_level

    @missions = Array(Obscura::Mission).new
    property :missions

    @current_mission : Obscura::Mission | Nil
    @current_mission = nil
    property :current_mission

    @current_combat : Obscura::Combat | Nil
    @current_combat = nil
    property :current_combat

    def won?
      @reputation >= MAXIMUM_REPUTATION
    end
  end
end
