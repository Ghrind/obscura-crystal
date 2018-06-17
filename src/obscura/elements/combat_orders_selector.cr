require "hydra"
require "./../combat_order_template"
require "./../player_order"
require "./../fighter"

module Obscura
  class CombatOrdersSelector < Hydra::Text
    ACTOR_IDENTIFIERS = ["a", "b", "c", "d"]

    @available_actors : Hash(String, Obscura::Fighter)
    @available_actors = Hash(String, Obscura::Fighter).new

    @available_targets = Array(String).new
    property :available_targets

    @orders = Array(Obscura::PlayerOrder).new
    getter :orders

    @current_order_template : Obscura::CombatOrderTemplate | Nil
    @current_order_template = nil

    @current_order = Obscura::PlayerOrder.new

    def initialize(id : String, options = Hash(Symbol, String).new)
      super
      new_order
    end

    def content
      if ready?
        @value = "Orders ready!"
      elsif @current_order.actor_required?
        @value = "Fighter? #{inactive_actor_ids.join(", ")}"
      elsif @current_order.order_required?
        @value = available_orders.map { |order| order_name(order) }.join(", ") + "?"
      elsif (order = current_order_template) && order.require_target
        @value = "Target? #{@available_targets.join(", ")}"
      end
      super
    end

    def players=(players : Array(Obscura::Fighter))
      players.each_with_index do |player, index|
        @available_actors[ACTOR_IDENTIFIERS[index]] = player
      end
    end

    private def available_orders
      orders = Array(Obscura::CombatOrderTemplate).new
      modes = current_actor.weapon.modes

      orders << Obscura::CombatOrderTemplate.new("s", "single-shot", true) if modes.includes?("single-shot")
      orders << Obscura::CombatOrderTemplate.new("b", "burst", true) if modes.includes?("burst")
      orders << Obscura::CombatOrderTemplate.new("p", "precision-shot", true) if modes.includes?("precision-shot")
      orders << Obscura::CombatOrderTemplate.new("u", "suppressive-fire") if modes.includes?("suppressive-fire")
      orders << Obscura::CombatOrderTemplate.new("w", "wait")
      orders << Obscura::CombatOrderTemplate.new("f", "flee")
      orders
    end

    private def order_name(order : Obscura::CombatOrderTemplate)
      order.name.sub(order.shortcut, "(#{order.shortcut.upcase})")
    end

    def ready?
      all_actors_ready? && current_order_complete?
    end

    private def all_actors_ready?
      inactive_actor_ids.empty?
    end

    private def current_actor() Obscura::Fighter
      @available_actors[@current_order.actor_id.not_nil!]
    end

    def reset!
      @current_order_template = nil
      @orders = Array(Obscura::PlayerOrder).new
      new_order
    end

    private def active_actor_ids
      @orders.map { |order| order.actor_id }
    end

    private def inactive_actor_ids
      ids = Array(String).new
      @available_actors.each do |id, actor|
        next if actor.dead?
        next if active_actor_ids.includes?(id)
        ids << id
      end
      ids
    end

    def receive_char(char : String)
      if @current_order.actor_required?
        @current_order.actor_id = char if inactive_actor_ids.includes?(char)
      elsif @current_order.order_required?
        template = find_template(char)
        if template
          @current_order.name = template.name
          auto_select_target if template.require_target
        end
      elsif order = current_order_template
        if order.require_target && @available_targets.includes?(char)
          @current_order.target_id = char
        end
      end
      if current_order_complete? && !ready?
        new_order
      end
    end

    private def auto_select_target
      if @available_targets.size == 1
        @current_order.target_id = @available_targets.first
      end
    end

    private def current_order_complete?
      return false if @current_order.actor_required?
      return false if @current_order.order_required?
      return false if @current_order.target_id.nil? && current_order_template.not_nil!.require_target
      true
    end

    private def new_order
      @current_order = Obscura::PlayerOrder.new
      @orders << @current_order
    end

    private def find_template(char : String)
      available_orders.find { |order| order.shortcut == char }
    end

    private def current_order_template
      available_orders.find { |order| order.name == @current_order.name }
    end

    def on_register(event_hub : Hydra::EventHub)
      event_hub.bind(id, "keypress.*") do |event_hub, event, elements, state|
        char = event.keypress.not_nil!.char
        receive_char(char)
        event_hub.broadcast(Hydra::Event.new("combat-orders.complete"), state, elements) if ready?
        false
      end
    end
  end
end
