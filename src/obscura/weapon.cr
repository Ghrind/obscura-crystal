module Obscura
  class Weapon
    #@hits_per_turn = 1
    #property :hits_per_turn

    @precision = 0
    property :precision

    #@precision_bonus = 10
    #property :precision_bonus

    @damage_min = 1
    property :damage_min

    @damage_max = 10
    property :damage_max

    #@modes = ["single_shot"]
    #property :modes

    @name = "Generic firearm"
    property :name
  end
end
