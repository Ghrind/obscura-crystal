module Obscura
  class Game
    INITIAL_REPUTATION = 0
    MAXIMUM_REPUTATION = 100

    property :reputation

    def initialize
      @reputation = INITIAL_REPUTATION
    end

    def won?
      @reputation >= MAXIMUM_REPUTATION
    end
  end
end
