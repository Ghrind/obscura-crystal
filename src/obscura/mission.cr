require "./encounter"

module Obscura
  class Mission
    DEFAULT_DIFFICULTY = 10
    DEFAULT_NAME = "Unnamed mission"

    @difficulty = DEFAULT_DIFFICULTY
    property :difficulty

    @name = DEFAULT_NAME
    property :name

    @completed = false
    property :completed

    @encounter = Obscura::Encounter.new
    property :encounter
  end
end
