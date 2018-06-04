module Obscura
  class Mission
    DEFAULT_DIFFICULTY = 10
    DEFAULT_NAME = "Unnamed mission"

    property :difficulty
    property :name
    property :completed

    def initialize
      @name = DEFAULT_NAME
      @difficulty = DEFAULT_DIFFICULTY
      @completed = false
    end
  end
end
