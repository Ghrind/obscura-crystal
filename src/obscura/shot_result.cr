module Obscura
  class ShotResult
    @shots = 0
    property :shots

    @hits = 0
    property :hits
    
    @damage = 0
    property :damage

    @attacker_name = "unknown attacker"
    property :attacker_name

    @target_name = "unknown target"
    property :target_name

    @attack_mode = "unknown attack mode"
    property :attack_mode

    @weapon_name = "unknown weapon"
    property :weapon_name
  end
end
