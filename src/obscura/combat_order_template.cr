module Obscura
  class CombatOrderTemplate
    getter :shortcut, :name, :require_target

    def initialize(@shortcut : String, @name : String, @require_target = false)
    end
  end
end
