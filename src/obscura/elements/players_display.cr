require "./../fighter"
require "hydra"

module Obscura
  class PlayersDisplay < Hydra::Text
    @players = Array(Obscura::Fighter).new
    property :players

    def content
      result = ["Fighter         HP  Weapon"]
      @players.each do |player|
        result << "#{player.name[0..14].ljust(15)} #{player.hit_points.to_s.ljust(3)} #{player.weapon.name}"
      end
      @value = result.join("\n")
      super
    end
  end
end
