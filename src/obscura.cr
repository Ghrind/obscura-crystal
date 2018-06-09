require "hydra"
require "./obscura/application"
require "./obscura/game"
require "./obscura/mission"
require "./obscura/mission_result"
require "./obscura/combat_action"
require "./obscura/actions/start_mission"
require "./obscura/actions/win_current_mission"
require "./obscura/actions/cancel_current_mission"
require "./obscura/actions/generate_missions"
require "./obscura/elements/missions_list"
require "./obscura/elements/combat_actions_selector"

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
  :type => "text",
  :template => "Reputation: {{game.reputation}}\nPlayer level: {{game.player_level}}",
  :visible => "false",
  :width => "30",
})

# Missions menu

missions_menu = Obscura::MissionsList.new("missions-menu", {
  :height => "12",
  :position => "center",
  :width => "24",
  :label => "Select a mission",
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
      elements.by_id("missions-menu").hide
      elements.by_id("combat-panel").show
      elements.by_id("combat-actions").show
      event_hub.focus("combat-actions")
    else
      app.game_message("You cannot start a mission that is already completed.")
    end
  end
  false
end

combat_positions = "    \n" \
                   " 1A \n" \
                   "    \n" \
                   "    \n" \

# Combat Panel
app.add_element({
  :id => "combat-panel",
  :type => "text",
  :label => "Combat",
  :value => combat_positions,
  :visible => "false",
  :position => "center",
  :autosize => "true",
})

# Combat Actions Selector
combat_actions = Obscura::CombatActionsSelector.new("combat-actions", {
  :label => "Combat actions",
  :visible => "false",
  :position => "0:30",
  :width => "35",
})
app.add_element(combat_actions)

combat_actions.available_actions = [
  Obscura::CombatAction.new("a", "Attack", true),
  Obscura::CombatAction.new("w", "Wait"),
  Obscura::CombatAction.new("f", "Flee"),
]

combat_actions.available_targets = ["1"]

app.bind("combat-actions.complete") do |event_hub, _, elements, _|
  actions = elements.by_id("combat-actions").as(Obscura::CombatActionsSelector)
  case actions.current_action.not_nil!.name
  when "Attack"
    app.game_message("Player attacks and kills the opponent")
    result = Obscura::WinCurrentMission.new(game).run!
    app.game_message("Mission completed \"#{result.mission_name}\".")

    if game.won?
      elements.show_only("winning-screen")
      event_hub.focus("winning-screen")
    else
      elements.show_only("missions-menu", "game-info", "messages")
      event_hub.focus("missions-menu")
    end
  when "Flee"
    app.game_message("Player has fled")
    Obscura::CancelCurrentMission.new(game).run!
    elements.show_only("missions-menu", "game-info", "messages")
    event_hub.focus("missions-menu")
  when "Wait"
    app.game_message("Player waits and is attacked")
  end
  actions.reset!
  true
end

# Messages
app.add_element({
  :id => "messages",
  :type => "logbox",
  :visible => "false",
  :label => "Messages",
  :position => "8:0",
  :width => "100",
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
