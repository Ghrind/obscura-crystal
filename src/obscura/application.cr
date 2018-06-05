require "hydra"

module Obscura
  class Application < Hydra::Application
    def game_message(message : String)
      @event_hub.trigger("messages", "add_message", { "message" => message })
    end
  end
end
