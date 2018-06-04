module Obscura
  class Game
    INITIAL_REPUTATION = 0
    MAXIMUM_REPUTATION = 100

    INITIAL_PLAYER_LEVEL = 1

    property :reputation
    property :player_level

    def initialize
      @reputation = INITIAL_REPUTATION
      @player_level = INITIAL_PLAYER_LEVEL
    end

    def won?
      @reputation >= MAXIMUM_REPUTATION
    end
  end
end
