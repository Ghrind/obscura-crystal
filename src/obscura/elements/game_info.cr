require "hydra"
require "./../game"

module Obscura
  class GameInfo < Hydra::Text
    @game = Obscura::Game.new
    property :game

    def content() Hydra::ExtendedString
      @value = "Reputation: #{@game.reputation}"
      super
    end
  end
end
