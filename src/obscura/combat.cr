require "./fighter"

module Obscura
  class Combat
    @player = Obscura::Fighter.new
    property :player

    @ennemies = Array(Obscura::Fighter).new
    property :ennemies

    @player_flees = false

    @turn_orders = Array(String).new

    def process_turn(order : Obscura::PlayerOrder)
      case order.name
      when "Attack"
        ennemy = @ennemies[order.target.not_nil!.to_i - 1]
        ennemy.dead = true
        @turn_orders << "Player attacks #{ennemy.name} and kills it"
      when "Flee"
        @player_flees = true
        @turn_orders << "Player flees"
      when "Wait"
        # Nothing
      end
      ennemies_alive.each do |ennemy|
        @turn_orders << "#{ennemy.name} attacks player and hits!"
      end
    end

    def turn_completed?
      @turn_orders.empty?
    end

    def unroll!
      @turn_orders.shift
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
