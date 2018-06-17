require "spec"
require "./../../../src/obscura/actions/generate_encounter"

describe "GenerateEncounter" do
  describe "#min_ennemies" do
    it "has the following values" do
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map do |difficulty|
        Obscura::GenerateEncounter.new(Obscura::GameMod.new, difficulty).min_ennemies
      end.should eq [1, 2, 2, 3, 3, 4, 4, 5, 5, 6]
    end
  end
  describe "#max_ennemies" do
    it "has the following values" do
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map do |difficulty|
        Obscura::GenerateEncounter.new(Obscura::GameMod.new, difficulty).max_ennemies
      end.should eq [1, 2, 2, 3, 3, 4, 5, 6, 7, 8]
    end
  end
end
