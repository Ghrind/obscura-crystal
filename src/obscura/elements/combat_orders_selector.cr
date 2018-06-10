require "hydra"
require "./../combat_order_template"
require "./../player_order"

module Obscura
  class CombatOrdersSelector < Hydra::Text
    @available_orders = Array(CombatOrderTemplate).new
    property :available_orders

    @available_targets = Array(String).new
    property :available_targets

    @player_order = Obscura::PlayerOrder.new
    getter :player_order

    @current_order_template : Obscura::CombatOrderTemplate | Nil
    @current_order_template = nil

    def content
      if ready?
        @value = "Orders ready!"
      elsif (order = @current_order_template) && order.require_target
        @value = "Target? #{@available_targets.join(", ")}"
      else
        @value = @available_orders.map { |order| order.name }.join(", ") + "?"
      end
      super
    end

    def ready?
      order = @current_order_template
      return false unless order
      return true unless order.require_target
      !player_order.target.nil?
    end

    def reset!
      @current_order_template = nil
      @player_order = Obscura::PlayerOrder.new
    end

    def on_register(event_hub : Hydra::EventHub)
      event_hub.bind(id, "keypress.*") do |event_hub, event, elements, state|
        char = event.keypress.not_nil!.char
        if order = @current_order_template
          if order.require_target && @available_targets.includes?(char)
            @player_order.target = char
          end
        else
          order = @available_orders.find { |order| order.shortcut == char }
          if order
            @current_order_template = order
            @player_order.name = order.name
          end
        end
        event_hub.broadcast(Hydra::Event.new("combat-orders.complete"), state, elements) if ready?
        false
      end
    end
  end
end
