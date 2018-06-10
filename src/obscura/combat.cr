require "./fighter"
require "./player_order"
require "./combat_order"

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
        @turn_orders << Obscura::CombatOrder.new(ennemy, "Attack", @player)
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
      when "Attack"
        actor = order.actor
        weapon = order.actor.weapon
        target = order.target.not_nil!
        precision = actor.precision + weapon.precision
        result = "#{actor.name} attacks #{target.name} with #{weapon.name}"

        roll = Random.rand(100) + 1
        if roll <= precision
          result += " and hits (#{roll}/#{precision})"
          damage = Random.rand(weapon.damage_max - weapon.damage_min) + weapon.damage_min
          target.hit_points -= damage
          target.hit_points = 0 if target.hit_points < 0
          result += " for #{damage} damage"
        else
          result += " and misses (#{roll}/#{precision})"
        end

        return result
      when "Flee"
        @player_flees = true
        return "Player tries to flee!"
      when "Wait"
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
