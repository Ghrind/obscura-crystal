module Obscura
  class InflictWeaponDamage
    def initialize(@target : Obscura::Fighter, @weapon : Obscura::Weapon)
    end

    def run!() Int32
      damage = Random.rand(@weapon.damage_max - @weapon.damage_min) + @weapon.damage_min
      damage -= @target.damage_reduction
      damage = 0 if damage < 0
      @target.hit_points -= damage
      @target.hit_points = 0 if @target.hit_points < 0
      damage
    end
  end
end
