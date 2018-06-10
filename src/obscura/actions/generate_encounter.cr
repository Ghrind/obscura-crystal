require "./../encounter"

module Obscura
  class GenerateEncounter
    def run!() Obscura::Encounter
      encounter = Obscura::Encounter.new
      (rand(8) + 1).times do
        ennemy = Obscura::Fighter.new
        ennemy.name = Obscura::GameMod.random_ennemy_type
        encounter.ennemies << ennemy
      end
      encounter
    end
  end
end
