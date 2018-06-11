require "hydra"

module Obscura
  class Application < Hydra::Application
    @game = Obscura::Game.new
    getter :game

    def game_message(message : String)
      @event_hub.trigger("messages", "add_message", { "message" => message })
    end
  end
end
