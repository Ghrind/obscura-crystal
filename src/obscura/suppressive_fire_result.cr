module Obscura
  class SuppressiveFireResult
    @attacker_name = "unknown attacker"
    property :attacker_name

    @weapon_name = "unknown weapon"
    property :weapon_name

    @target_names = Array(String).new
    property :target_names

    @damages = Array(Int32).new
    property :damages

    @hits = 0
    property :hits
  end
end
