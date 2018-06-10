module Obscura
  class CombatOrder
    property :actor

    property :name

    property :target

    def initialize(@actor : Obscura::Fighter, @name : String, @target : Obscura::Fighter | Nil = nil)
    end
  end
end
