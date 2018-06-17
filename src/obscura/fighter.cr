require "./weapon"

module Obscura
  class Fighter
    DEFAULT_LEVEL = 1
    DEFAULT_NAME = "Unidentified fighter"

    @level = DEFAULT_LEVEL
    property :level

    @name = DEFAULT_NAME
    property :name

    @precision = 50 # Ability to hit a target with a ranged weapon
    property :precision

    @weapon = Obscura::Weapon.new
    property :weapon

    @hit_points = 30
    property :hit_points

    @damage_reduction = 0
    property :damage_reduction

    @prefered_weapons = Array(String).new
    property :prefered_weapons

    def dead?
      @hit_points <= 0
    end
  end
end
