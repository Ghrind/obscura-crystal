require "hydra"
require "./../combat_action"
require "./../player_action"

module Obscura
  class CombatActionsSelector < Hydra::Text
    @available_actions = Array(CombatAction).new
    property :available_actions

    @available_targets = Array(String).new
    property :available_targets

    @player_action = Obscura::PlayerAction.new
    getter :player_action

    @current_action : Obscura::CombatAction | Nil
    @current_action = nil

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
      !player_action.target.nil?
    end

    def reset!
      @current_action = nil
      @player_action = PlayerAction.new
    end

    def on_register(event_hub : Hydra::EventHub)
      event_hub.bind(id, "keypress.*") do |event_hub, event, elements, state|
        char = event.keypress.not_nil!.char
        if action = @current_action
          if action.require_target && @available_targets.includes?(char)
            @player_action.target = char
          end
        else
          action = @available_actions.find { |action| action.shortcut == char }
          if action
            @current_action = action
            @player_action.name = action.name
          end
        end
        event_hub.broadcast(Hydra::Event.new("combat-actions.complete"), state, elements) if ready?
        false
      end
    end
  end
end
