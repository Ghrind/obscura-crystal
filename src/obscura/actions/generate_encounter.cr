require "./../encounter"
require "./../game_mod"

module Obscura
  class GenerateEncounter

    def initialize(@game_mod : Obscura::GameMod, @difficulty : Int32)
    end

    def min_ennemies
      @difficulty / 2 + 1
    end

    def max_ennemies
      [8 - (10 - @difficulty), min_ennemies].max
    end

    def run!() Obscura::Encounter
      encounter = Obscura::Encounter.new

      ennemies_count = rand(max_ennemies - min_ennemies) + min_ennemies

      (ennemies_count).times do
        ennemy = @game_mod.random_ennemy.dup
        ennemy.weapon = @game_mod.find_weapon(ennemy.prefered_weapons.first).dup

        # Leveling
        ennemy.precision += @difficulty
        ennemy.hit_points *= @difficulty
        ennemy.weapon.damage_min *= @difficulty
        ennemy.weapon.damage_max *= @difficulty

        encounter.ennemies << ennemy
      end
      encounter
    end
  end
end
