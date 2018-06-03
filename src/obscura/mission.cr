module Obscura
  class Mission
    DEFAULT_DIFFICULTY = 10
    DEFAULT_NAME = "Unnamed mission"

    property :difficulty
    property :name

    def initialize
      @name = DEFAULT_NAME
      @difficulty = DEFAULT_DIFFICULTY
    end
  end
end
