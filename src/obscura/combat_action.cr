module Obscura
  class CombatAction
    getter :shortcut, :name, :require_target

    def initialize(@shortcut : String, @name : String, @require_target = false)
    end
  end
end
