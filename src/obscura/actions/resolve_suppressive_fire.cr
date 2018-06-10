require "./../suppressive_fire_result"
require "./resolve_shot"

module Obscura
  class ResolveSuppressiveFire
    PRECISION_MODIFICATOR = -15

    def initialize(@attacker : Obscura::Fighter, @targets : Array(Obscura::Fighter))
    end

    def run!() Obscura::SuppressiveFireResult
      result = Obscura::SuppressiveFireResult.new
      result.attacker_name = @attacker.name
      result.weapon_name = @attacker.weapon.name

      eligible_targets = @targets.dup.shuffle

      @attacker.weapon.hits_per_turn.times do
        break if eligible_targets.empty?
        target = eligible_targets.pop
        shot_result = Obscura::ResolveShot.new(@attacker, target, "single-shot", PRECISION_MODIFICATOR).run!
        if shot_result.hits > 0
          result.hits += shot_result.hits
          result.target_names << target.name
          result.damages << shot_result.damage
        end
      end

      result
    end
  end
end
