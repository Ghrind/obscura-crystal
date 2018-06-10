require "./fighter"

module Obscura
  class Combat
    @player = Obscura::Fighter.new
    @ennemies = Array(Obscura::Fighter).new

    property :player, :ennemies
  end
end
