require "hydra"
require "./obscura/game"
require "./obscura/mission"

app = Hydra::Application.setup
game = Obscura::Game.new

def generate_missions() Array(Obscura::Mission)
  missions = Array(Obscura::Mission).new
  10.times do
    mission = Obscura::Mission.new
    mission.difficulty = (Random.rand(10) + 1) * 10
    missions.push mission
  end
  missions
end

missions = generate_missions

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
    elements.by_id("missions-menu").show
    event_hub.focus("missions-menu")
  end
  false
end

# Game info

app.add_element({
  :id => "game-info",
  :type => "text",
  :template => "Reputation: {{game.reputation}}",
  :visible => "false",
})

app.bind("ready") do |_, _, _, state|
  state["game.reputation"] = game.reputation.to_s
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
  missions.each do |mission|
    menu.add_item("#{mission.name} (#{mission.difficulty})")
  end
  true
end

app.bind("missions-menu", "keypress.j", "missions-menu", "select_down")
app.bind("missions-menu", "keypress.k", "missions-menu", "select_up")

app.bind("missions-menu", "keypress.enter") do |event_hub, _, elements, state|
  menu = elements.by_id("missions-menu")
  if menu.selected != nil
    mission = missions[menu.selected.not_nil!]
    game.reputation += mission.difficulty
    state["game.reputation"] = game.reputation.to_s
  end
  if game.won?
    elements.by_id("winning-screen").show
    event_hub.focus("winning-screen")
  end
  false
end

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
