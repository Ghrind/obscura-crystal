require "./encounter"

module Obscura
  class Mission
    DEFAULT_DIFFICULTY = 1
    DEFAULT_NAME = "Unnamed mission"

    @difficulty = DEFAULT_DIFFICULTY
    property :difficulty

    @reputation_bonus = 10
    property :reputation_bonus

    @name = DEFAULT_NAME
    property :name

    @completed = false
    property :completed

    @encounter = Obscura::Encounter.new
    property :encounter
  end
end
