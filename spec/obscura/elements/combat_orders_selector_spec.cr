require "spec"
require "../../../src/obscura/elements/combat_orders_selector"

def init_selector
  selector = Obscura::CombatOrdersSelector.new("foobar")
  selector.available_actors = ["a", "b"]
  selector.available_orders = [
    Obscura::CombatOrderTemplate.new("f", "foo", false),
    Obscura::CombatOrderTemplate.new("b", "bar", true),
  ]
  selector
end

describe "CombatOrdersSelector" do
  describe "#content" do
    context "when an actor is required" do
      it "show all actors" do
        selector = init_selector
        selector.content.stripped.should eq ["┌──────────┐",
                                             "│Who? a, b │",
                                             "└──────────┘"].join("\n")
      end
      context "when some actors already have an order" do
        it "shows only inactive actors" do
          selector = init_selector
          selector.receive_char("a")
          selector.receive_char("f")
          selector.content.stripped.should eq ["┌──────────┐",
                                               "│Who? b    │",
                                               "└──────────┘"].join("\n")
        end
      end
    end
    
  end
  describe "#receive_char" do
    context "when expecting an actors id" do
      context "when receiving an actor id" do
        it "stores the current actor id" do
          selector = init_selector
          selector.receive_char "a"
          selector.orders.empty?.should eq false
          selector.orders.last.actor_id.should eq "a"
        end
      end
      context "when receiving another letter" do
        it "does nothing" do
          selector = init_selector
          selector.receive_char "e"
          selector.orders.size.should eq 1
          selector.orders.last.actor_required?.should eq true
        end
      end
      context "when the order for that actor is already defined" do
        it "does nothing" do
          selector = init_selector
          selector.receive_char "a"
          selector.receive_char "f"
          selector.receive_char "a"
          selector.orders.size.should eq 2
          selector.orders.last.actor_required?.should eq true
        end
      end
    end
    context "when expecting an action shortcut" do
      context "when receiving an action shortcut" do
        it "stores the action name" do
          selector = init_selector
          selector.receive_char "a"
          selector.receive_char "f"
          selector.orders.empty?.should eq false
          selector.orders.first.name.should eq "foo"
        end
        context "when the order is complete" do
          it "saves the order and init another" do
            selector = init_selector
            selector.receive_char "a"
            selector.receive_char "f"
            selector.orders.size.should eq 2
            selector.orders.last.actor_required?.should eq true
          end
        end
        context "when no more orders are required" do
          it "does not add a blank order" do
            selector = init_selector
            selector.receive_char "a" # Actor a
            selector.receive_char "f" # Order foo
            selector.receive_char "b" # Actor b
            selector.receive_char "f" # Order foo
            selector.orders.size.should eq 2
          end
        end
      end
    end
  end
end
