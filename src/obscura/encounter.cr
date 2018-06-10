require "./fighter"

module Obscura
  class Encounter
    @ennemies = Array(Obscura::Fighter).new
    property :ennemies
  end
end
