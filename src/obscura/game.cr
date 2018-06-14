require "./mission"
require "./combat"
require "./fighter"

module Obscura
  class Game
    INITIAL_REPUTATION = 0
    MAXIMUM_REPUTATION = 100

    @reputation = INITIAL_REPUTATION
    property :reputation

    @players = Array(Obscura::Fighter).new
    property :players

    @missions = Array(Obscura::Mission).new
    property :missions

    @current_mission : Obscura::Mission | Nil
    @current_mission = nil
    property :current_mission

    @current_combat : Obscura::Combat | Nil
    @current_combat = nil
    property :current_combat

    @mod = Obscura::GameMod.new
    property :mod

    def won?
      @reputation >= MAXIMUM_REPUTATION
    end

    def lost?
      @players.all? { |player| player.dead }
    end
  end
end
