require "./inflict_weapon_damage"
require "./../shot_result"

module Obscura
  class ResolveShot
    def initialize(@actor : Obscura::Fighter, @target : Obscura::Fighter, @mode : String)
    end

    def run!() Obscura::ShotResult
      result = Obscura::ShotResult.new
      weapon = @actor.weapon
      precision = @actor.precision + weapon.precision
      precision += weapon.precision_bonus if @mode == "precision-shot"

      result.attacker_name = @actor.name
      result.attack_mode = @mode
      result.target_name = @target.name
      result.weapon_name = @actor.weapon.name

      shots = @mode == "burst" ? weapon.hits_per_turn : 1
      hits = 0

      shots.times do
        roll = Random.rand(100) + 1
        if roll <= precision
          hits += 1
        end
      end
      if hits > 0
        hits.times do
          result.damage += Obscura::InflictWeaponDamage.new(@target, weapon).run!
        end
      end

      result.shots = shots
      result.hits = hits
      result
    end
  end
end
