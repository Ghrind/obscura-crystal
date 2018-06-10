require "hydra"
require "./obscura/application"
require "./obscura/game"
require "./obscura/mission"
require "./obscura/mission_result"
require "./obscura/combat"
require "./obscura/combat_order_template"
require "./obscura/actions/start_mission"
require "./obscura/actions/win_current_mission"
require "./obscura/actions/cancel_current_mission"
require "./obscura/actions/generate_missions"
require "./obscura/elements/missions_list"
require "./obscura/elements/combat_orders_selector"
require "./obscura/elements/combat_positions"

app = Obscura::Application.setup
game = app.game
Obscura::GenerateMissions.new(game).run!

# Main menu

app.add_element({
  :id => "main-menu",
  :type => "list",
  :height => "6",
  :position => "center",
  :width => "22",
  :label => "Welcome to Obscura!",
})

app.bind("ready") do |event_hub, _, elements, _|
  menu = elements.by_id("main-menu").as(Hydra::List)
  menu.add_item("New Game")
  menu.add_item("Quit")
  true
end

app.bind("main-menu", "keypress.j", "main-menu", "select_down")
app.bind("main-menu", "keypress.k", "main-menu", "select_up")

app.bind("main-menu", "keypress.enter") do |event_hub, _, elements, _|
  menu = elements.by_id("main-menu").as(Hydra::List)
  case menu.selected
  when 1 # Exit
    event_hub.trigger("application", "stop")
  when 0 # New Game
    menu.hide
    elements.by_id("game-info").show
    elements.by_id("messages").show
    elements.by_id("missions-menu").show
    event_hub.focus("missions-menu")
  end
  false
end

# Game info

app.add_element({
  :id => "game-info",
  :height => "12",
  :label => "Game Info",
  :type => "text",
  :template => "Reputation: {{game.reputation}}\nPlayer level: {{game.player_level}}",
  :visible => "false",
  :width => "30",
})

# Missions menu

missions_menu = Obscura::MissionsList.new("missions-menu", {
  :height => "12",
  :position => "center",
  :width => "29",
  :label => "Select a mission",
  :position => "0:30",
  :visible => "false",
})
app.add_element(missions_menu)

app.bind("ready") do |event_hub, _, elements, _|
  menu = elements.by_id("missions-menu").as(Obscura::MissionsList)
  menu.missions = game.missions
  menu.select_first
  true
end

app.bind("missions-menu", "keypress.j", "missions-menu", "select_down")
app.bind("missions-menu", "keypress.k", "missions-menu", "select_up")

app.bind("missions-menu", "keypress.enter") do |event_hub, _, elements, _|
  menu = elements.by_id("missions-menu").as(Hydra::List)
  if menu.selected != nil
    result = Obscura::StartMission.new(game, menu.selected.not_nil!).run!
    if result
      app.game_message("Starting mission \"#{game.current_mission.not_nil!.name}\"")

      combat_panel = elements.by_id("combat-panel").as(Obscura::CombatPositions)
      combat = Obscura::Combat.new
      combat.ennemies = game.current_mission.not_nil!.encounter.ennemies
      game.current_combat = combat
      combat_panel.combat = combat

      combat_orders = elements.by_id("combat-orders").as(Obscura::CombatOrdersSelector)
      combat_orders.available_orders = [
        Obscura::CombatOrderTemplate.new("a", "Attack", true),
        Obscura::CombatOrderTemplate.new("w", "Wait"),
        Obscura::CombatOrderTemplate.new("f", "Flee"),
      ]
      combat_orders.available_targets = combat.identifiers(combat.ennemies)

      elements.by_id("missions-menu").hide
      combat_panel.show
      combat_orders.show
      event_hub.focus("combat-orders")
    else
      app.game_message("You cannot start a mission that is already completed.")
    end
  end
  false
end

# Combat Panel
combat_panel = Obscura::CombatPositions.new("combat-panel", {
  :height => "12",
  :label => "Combat",
  :visible => "false",
  :position => "0:30",
  :width => "30",
})
app.add_element(combat_panel)

# Combat Orders Selector
combat_orders = Obscura::CombatOrdersSelector.new("combat-orders", {
  :label => "Combat orders",
  :visible => "false",
  :position => "12:0",
  :width => "60",
})
app.add_element(combat_orders)

combat_unroller = Hydra::Element.new("combat-unroller", {
  :visible => "false"
})
app.add_element(combat_unroller)

app.bind("combat-unroller", "keypress. ") do |event_hub, _, elements, state|
  combat = game.current_combat.not_nil!
  if combat.turn_completed?
    event_hub.broadcast(Hydra::Event.new("combat-orders.turn_complete"), state, elements)
  else
    result = combat.unroll!
    app.game_message(result)
  end
  true
end

app.bind("combat-orders.turn_complete") do |event_hub, _, elements|
  orders = elements.by_id("combat-orders").as(Obscura::CombatOrdersSelector)
  orders.reset!

  combat = game.current_combat.not_nil!
  case game.current_combat.not_nil!.status
  when :player_wins
    app.game_message("Victory!")
    result = Obscura::WinCurrentMission.new(game).run!
    app.game_message("Mission completed \"#{result.mission_name}\".")

    if game.won?
      elements.show_only("winning-screen")
      event_hub.focus("winning-screen")
    else
      elements.show_only("missions-menu", "game-info", "messages")
      event_hub.focus("missions-menu")
    end
  when :player_flees
    app.game_message("Player has fled")
    Obscura::CancelCurrentMission.new(game).run!
    elements.show_only("missions-menu", "game-info", "messages")
    event_hub.focus("missions-menu")
  when :ongoing
    orders.available_targets = combat.identifiers(combat.ennemies_alive)
    event_hub.focus("combat-orders")
  end
  true
end

app.bind("combat-orders.complete") do |event_hub, _, elements, _|
  orders = elements.by_id("combat-orders").as(Obscura::CombatOrdersSelector)
  combat = game.current_combat.not_nil!
  combat.process_turn(orders.player_order)
  event_hub.focus("combat-unroller")
  true
end

# Messages
app.add_element({
  :id => "messages",
  :type => "logbox",
  :visible => "false",
  :label => "Messages",
  :position => "15:0",
  :width => "90",
})

# Winning screen
app.add_element({
  :id => "winning-screen",
  :position => "center",
  :visible => "false",
  :type => "text",
  :label => "Victory!",
  :value => "You have won the game!",
  :autosize => "true",
})

app.bind("winning-screen", "keypress.*", "application", "stop")

# Application start

app.bind("ready") do |event_hub, _, elements, _|
  event_hub.focus("main-menu")
  true
end

app.bind("keypress.ctrl-c", "application", "stop")

app.run
app.teardown
puts "Thanks for playing Obscura!"
