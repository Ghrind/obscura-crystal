require "hydra"
require "./../game"

module Obscura
  class GameInfo < Hydra::Text
    @game = Obscura::Game.new
    property :game

    def content() Hydra::ExtendedString
      @value = ["Reputation: #{@game.reputation}",
                "Player level: #{@game.player.level}",
                "Player HP: #{@game.player.hit_points}"].join("\n")

      super
    end
  end
end
