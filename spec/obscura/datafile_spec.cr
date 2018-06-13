require "spec"
require "../../src/obscura/datafile"
require "../../src/obscura/weapon"

def datafile_path(name : String) String
  File.join(File.dirname(__FILE__), "#{name}.csv")
end

describe "Datafile" do
  describe "as weapons" do
    it "loads data as weapons" do
      datafile = Obscura::Datafile(Obscura::Weapon).new(datafile_path("weapons"))
      datafile.as_weapons!
      datafile.content.empty?.should eq false
      weapon = datafile.content.first
      weapon.class.should eq Obscura::Weapon
      weapon.precision.should eq 10
      weapon.name.should eq "Pistol"
      weapon.precision_bonus.should eq 15
      weapon.damage_min.should eq 10
      weapon.damage_max.should eq 100
      weapon.modes.should eq ["single-shot", "precision-shot"]
      weapon.hits_per_turn.should eq 2
    end
  end
end
