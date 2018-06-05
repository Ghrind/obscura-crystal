require "./obscura/application"
require "./obscura/game"
require "./obscura/mission"
require "./obscura/mission_result"
require "./obscura/actions/start_mission"
require "./obscura/actions/win_current_mission"
require "./obscura/actions/generate_missions"

app = Obscura::Application.setup
game = Obscura::Game.new
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
  menu = elements.by_id("main-menu")
  menu.add_item("New Game")
  menu.add_item("Quit")
  true
end

app.bind("main-menu", "keypress.j", "main-menu", "select_down")
app.bind("main-menu", "keypress.k", "main-menu", "select_up")

app.bind("main-menu", "keypress.enter") do |event_hub, _, elements, _|
  menu = elements.by_id("main-menu")
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
})

app.bind("ready") do |_, _, _, state|
  state["game.reputation"] = game.reputation.to_s
  state["game.player_level"] = game.player_level.to_s
  true
end

# Missions menu

app.add_element({
  :id => "missions-menu",
  :type => "list",
  :height => "12",
  :position => "center",
  :width => "24",
  :label => "Select a mission",
  :visible => "false",
})

app.bind("ready") do |event_hub, _, elements, _|
  menu = elements.by_id("missions-menu")
  game.missions.each do |mission|
    menu.add_item("#{mission.name} (#{mission.difficulty})")
  end
  true
end

app.bind("missions-menu", "keypress.j", "missions-menu", "select_down")
app.bind("missions-menu", "keypress.k", "missions-menu", "select_up")

app.bind("missions-menu", "keypress.enter") do |event_hub, _, elements, _|
  menu = elements.by_id("missions-menu")
  if menu.selected != nil
    result = Obscura::StartMission.new(game, menu.selected.not_nil!).run!
    if result
      app.game_message("Starting mission \"#{game.current_mission.not_nil!.name}\"")
      elements.by_id("missions-menu").hide
      elements.by_id("fight-panel").show
      event_hub.focus("fight-panel")
    else
      app.game_message("You cannot start a mission that is already completed.")
    end
  end
  false
end

# Fight Panel
app.add_element({
  :id => "fight-panel",
  :type => "text",
  :label => "Fight",
  :value => "foobar",
  :visible => "false",
  :position => "center",
})

app.bind("fight-panel", "keypress.enter") do |event_hub, _, elements, state|
  menu = elements.by_id("missions-menu")
  mission = game.current_mission.not_nil!
  Obscura::WinCurrentMission.new(game).run!
  app.game_message("Mission completed \"#{mission.name}\".")
  event_hub.trigger("missions-menu", "change_item", { "index" => menu.selected.to_s, "item" => "<green-fg>#{mission.name} (#{mission.difficulty})</green-fg>" })
  state["game.player_level"] = game.player_level.to_s
  state["game.reputation"] = game.reputation.to_s

  if game.won?
    elements.each { |element| element.hide }
    elements.by_id("winning-screen").show
    event_hub.focus("winning-screen")
  else
    elements.by_id("fight-panel").hide
    elements.by_id("missions-menu").show
    event_hub.focus("missions-menu")
  end
  false
end

# Messages
app.add_element({
  :id => "messages",
  :type => "logbox",
  :visible => "false",
  :label => "Messages",
  :position => "8:0",
})

# Winning screen
app.add_element({
  :id => "winning-screen",
  :position => "center",
  :visible => "false",
  :type => "text",
  :label => "Victory!",
  :value => "You have won the game!",
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
