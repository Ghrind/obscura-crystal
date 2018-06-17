require "spec"
require "./../../../src/obscura/elements/players_display"

def players
  Array(Obscura::Fighter).new.tap do|array|
    player = Obscura::Fighter.new
    player.name = "Negasonic Teenage Warhead"
    player.weapon.name = "Energy Wave"
    player.hit_points = 50
    array << player

    player = Obscura::Fighter.new
    player.name = "Deadpool"
    player.weapon.name = "Pistol"
    player.hit_points = 1
    array << player

    player = Obscura::Fighter.new
    player.name = "Colossus"
    player.weapon.name = "Fists"
    player.hit_points = 100
    array << player

    player = Obscura::Fighter.new
    player.name = "Peter"
    player.weapon.name = "None"
    player.hit_points = 50
    array << player
  end
end

describe "Obscura::PlayersDisplay" do

  describe "#content" do
    it "shows players information" do
      element = Obscura::PlayersDisplay.new("id", { :width => "50", :height => "6" })
      element.players = players
      element.content.stripped.should eq ["┌────────────────────────────────────────────────┐",
                                          "│Fighter         HP  Weapon                      │",
                                          "│Negasonic Teena 50  Energy Wave                 │",
                                          "│Deadpool        1   Pistol                      │",
                                          "│Colossus        100 Fists                       │",
                                          "│Peter           50  None                        │",
                                          "└────────────────────────────────────────────────┘"].join("\n")





    end
  end
end
