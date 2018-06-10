require "./fighter"
require "./player_order"
require "./combat_order"
require "./actions/resolve_shot"
require "./actions/resolve_suppressive_fire"

module Obscura
  class Combat
    @player = Obscura::Fighter.new
    property :player

    @ennemies = Array(Obscura::Fighter).new
    property :ennemies

    @player_flees = false

    @turn_orders = Array(CombatOrder).new

    def prepare_turn(order : Obscura::PlayerOrder)
      @turn_orders << Obscura::CombatOrder.new(@player, order.name, ennemy_at(order.target))
      ennemies_alive.each do |ennemy|
        action = ennemy.weapon.modes.sample
        @turn_orders << Obscura::CombatOrder.new(ennemy, action, @player)
      end
    end

    def ennemy_at(identifier : String | Nil)
      return nil unless identifier
      index = identifier.to_i - 1
      @ennemies[index]? ? @ennemies[index] : nil
    end

    def turn_completed?
      @turn_orders.empty?
    end

    def unroll!() : String
      order = @turn_orders.shift
      if order.actor.dead
        return "#{order.actor.name} is dead and cannot do anything..."
      end
      case order.name
      when "single-shot", "precision-shot", "burst"
        result = Obscura::ResolveShot.new(order.actor, order.target.not_nil!, order.name).run!
        message = "#{result.attacker_name} attacks #{result.target_name} with #{result.weapon_name} (#{result.attack_mode})"
        if result.hits > 0
          message += " and hits"
          message += " #{result.hits} times" if result.shots > 1
          message += " for #{result.damage} damage"
        else
          message += " and misses"
          message += " #{result.shots} times" if result.shots > 1
        end
        return message
      when "suppressive-fire"
        targets = order.actor == @player ? ennemies_alive : [@player]
        result = ResolveSuppressiveFire.new(order.actor, targets).run!
        if result.hits > 0
          message = "#{result.attacker_name} shoots with #{result.weapon_name} (suppressive-fire) and hits #{result.target_names.join(", ")} for #{result.damages.join(", ")} damages"
        else
          message = "#{result.attacker_name} shoots with #{result.weapon_name} and misses"
        end
        return message
      when "flee"
        @player_flees = true
        return "Player tries to flee!"
      when "wait"
        return "Player waits..."
      else
        return "An unexpected order has been queued..."
      end
    end

    def status
      return :player_flees if @player_flees
      return :player_wins if all_enemies_dead?
      :ongoing
    end

    def ennemies_alive() Array(Fighter)
      @ennemies.select { |ennemy| !ennemy.dead }
    end

    def all_enemies_dead?() Bool
      ennemies_alive.empty?
    end

    def identifiers(ennemies : Array(Fighter)) : Array(String)
      ids = Array(String).new
      @ennemies.each_with_index do |ennemy, index|
        ids << (index + 1).to_s if ennemies.includes?(ennemy)
      end
      ids
    end
  end
end
