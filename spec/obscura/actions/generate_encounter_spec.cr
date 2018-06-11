require "spec"
require "./../../../src/obscura/actions/generate_encounter"

describe "GenerateEncounter" do
  describe "#min_ennemies" do
    it "has the following values" do
      [10, 20, 30, 40, 50, 60, 70, 80, 90, 100].map do |difficulty|
        Obscura::GenerateEncounter.new(difficulty).min_ennemies
      end.should eq [1, 2, 2, 3, 3, 4, 4, 5, 5, 6]
    end
  end
  describe "#max_ennemies" do
    it "has the following values" do
      [10, 20, 30, 40, 50, 60, 70, 80, 90, 100].map do |difficulty|
        Obscura::GenerateEncounter.new(difficulty).max_ennemies
      end.should eq [1, 2, 2, 3, 3, 4, 5, 6, 7, 8]
    end
  end
end
