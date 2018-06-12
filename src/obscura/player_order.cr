module Obscura
  class PlayerOrder
    NO_ORDER = "no order"
    NO_ACTOR_ID = ""

    @name = NO_ORDER
    property :name

    @actor_id = NO_ACTOR_ID
    property :actor_id

    @target_id : String | Nil
    @target_id = nil
    property :target_id

    def actor_required?
      @actor_id == NO_ACTOR_ID
    end

    def order_required?
      @name == NO_ORDER
    end
  end
end
