require "hydra"
require "./../combat_action"

module Obscura
  class CombatActionsSelector < Hydra::Text
    property :available_actions
    property :available_targets
    property :current_action
    property :current_target
    @current_action : CombatAction | Nil
    @current_target : String | Nil

    def initialize(id : String, options = Hash(Symbol, String).new)
      super
      @available_actions = Array(CombatAction).new
      @available_targets = Array(String).new
      @current_action = nil
      @current_target = nil
    end

    def content
      if ready?
        @value = "Actions ready!"
      elsif (action = @current_action) && action.require_target
        @value = "Target? #{@available_targets.join(", ")}"
      else
        @value = @available_actions.map { |action| action.name }.join(", ") + "?"
      end
      super
    end

    def ready?
      action = @current_action
      return false unless action
      return true unless action.require_target
      !@current_target.nil?
    end

    def reset!
      @current_action = nil
      @current_target = nil
    end

    def on_register(event_hub : Hydra::EventHub)
      event_hub.bind(id, "keypress.*") do |event_hub, event, elements, state|
        char = event.keypress.not_nil!.char
        if action = @current_action
          if action.require_target && @available_targets.includes?(char)
            @current_target = char
          end
        else
          action = @available_actions.find { |action| action.shortcut == char }
          if action
            @current_action = action
          end
        end
        event_hub.broadcast(Hydra::Event.new("combat-actions.complete"), state, elements) if ready?
        false
      end
    end
  end
end
