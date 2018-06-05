require "hydra"

module Obscura
  class Application < Hydra::Application
    @game = Obscura::Game.new
    getter :game

    def game_message(message : String)
      @event_hub.trigger("messages", "add_message", { "message" => message })
    end

    private def update_state
      @state["game.reputation"] = @game.reputation.to_s
      @state["game.player_level"] = @game.player_level.to_s
    end

    private def update_screen
      update_state
      super
    end
  end
end
