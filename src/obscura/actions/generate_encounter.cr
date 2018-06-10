require "./../encounter"

module Obscura
  class GenerateEncounter
    def run!() Obscura::Encounter
      encounter = Obscura::Encounter.new
      (rand(8) + 1).times do
        ennemy = Obscura::Fighter.new
        ennemy.name = Obscura::GameMod.random_ennemy_type
        case ennemy.name
        when "Violator"
          ennemy.hit_points = 6
          weapon = Weapon.new
          weapon.name = "Sniper rifle"
          weapon.damage_min = 8
          weapon.damage_max = 12
          #weapon.hits_per_turn = 1
          #weapon.modes = ["single_shot", "precision_shot"]
          weapon.precision = -30
          #weapon.precision_bonus = 50
          ennemy.weapon = weapon
        when "Cybermaw"
          ennemy.hit_points = 10
          weapon = Weapon.new
          weapon.name = "Shotgun"
          weapon.damage_min = 2
          weapon.damage_max = 12
          #weapon.hits_per_turn = 1
          #weapon.modes = ["single_shot"]
          weapon.precision = -20
          #weapon.precision_bonus = 0
          ennemy.weapon = weapon
        when "Agressor"
          ennemy.hit_points = 6
          weapon = Weapon.new
          weapon.name = "Machinegun"
          weapon.damage_min = 1
          weapon.damage_max = 5
          #weapon.hits_per_turn = 3
          #weapon.modes = ["single_shot", "precision_shot", "shootout"]
          weapon.precision = -10
          #weapon.precision_bonus = 10
          ennemy.weapon = weapon
        else
        end
        encounter.ennemies << ennemy
      end
      encounter
    end
  end
end
