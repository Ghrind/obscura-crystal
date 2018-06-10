require "./fighter"

module Obscura
  class Combat
    @player = Obscura::Fighter.new
    property :player

    @ennemies = Array(Obscura::Fighter).new
    property :ennemies

    @player_flees = false

    def process_action(action : CombatAction, target : String | Nil)
      case action.name
      when "Attack"
        @ennemies[target.not_nil!.to_i - 1].dead = true
      when "Flee"
        @player_flees = true
      when "Wait"
        # Nothing
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
