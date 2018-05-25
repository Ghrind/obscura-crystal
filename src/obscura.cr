require "hydra"

app = Hydra::Application.setup

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
    elements.by_id("class-menu").show
    event_hub.focus("class-menu")
  end
  false
end

# Class menu

app.add_element({
  :id => "class-menu",
  :type => "list",
  :height => "6",
  :position => "center",
  :width => "22",
  :label => "Pick a class",
  :visible => "false"
})

app.bind("ready") do |event_hub, _, elements, _|
  # Initialize class menu
  menu = elements.by_id("class-menu")
  menu.add_item("Warrior")
  menu.add_item("Mage")
  menu.add_item("Priest")
  menu.add_item("Thief")
  true
end

app.bind("class-menu", "keypress.j", "class-menu", "select_down")
app.bind("class-menu", "keypress.k", "class-menu", "select_up")
app.bind("class-menu", "keypress.escape") do |event_hub, _, elements, _|
  elements.by_id("class-menu").hide
  elements.by_id("main-menu").show
  event_hub.focus("main-menu")
  false
end

app.bind("class-menu", "keypress.enter") do |event_hub, _, elements, _|
  menu = elements.by_id("class-menu")
  case menu.selected
  when 1 # Exit
    event_hub.trigger("application", "stop")
  when 0 # New Game
    menu.hide
    elements.by_id("class-menu").show
    event_hub.focus("class-menu")
  end
  false
end

# Application start

app.bind("ready") do |event_hub, _, elements, _|
  event_hub.focus("main-menu")
  true
end

app.bind("keypress.ctrl-c", "application", "stop")


app.run
app.teardown
puts "Thanks for playing Obscura!"
