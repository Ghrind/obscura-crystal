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
        actor = order.actor
        weapon = order.actor.weapon
        target = order.target.not_nil!
        precision = actor.precision + weapon.precision
        precision += weapon.precision_bonus if order.name == "precision-shot"
        result = "#{actor.name} attacks #{target.name} with #{weapon.name} (#{order.name})"

        shots = order.name == "burst" ? weapon.hits_per_turn : 1
        hits = 0

        shots.times do
          roll = Random.rand(100) + 1
          if roll <= precision
            hits += 1
          end
        end
        if hits > 0
          result += " and hits #{hits} times"
          damage = 0
          hits.times do
            damage += Random.rand(weapon.damage_max - weapon.damage_min) + weapon.damage_min
          end
          target.hit_points -= damage
          target.hit_points = 0 if target.hit_points < 0
          result += " for #{damage} damage"
        else
          result += " and misses #{shots} times"
        end

        return result
      when "shootout"
        return "Shootout!"
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
