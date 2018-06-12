require "hydra"
require "./../game"

module Obscura
  class GameInfo < Hydra::Text
    @game = Obscura::Game.new
    property :game

    def content() Hydra::ExtendedString
      @value = ["Reputation: #{@game.reputation}",
                "Players HP: #{@game.players.map { |player| player.hit_points }.join("/")}"].join("\n")

      super
    end
  end
end
