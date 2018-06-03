require "spec"
require "../../src/obscura/game"

describe "Game" do
  describe "#won?" do
    it "returns false" do
      game = Obscura::Game.new
      game.won?.should eq false
    end
    context "when player has reached maximum reputation" do
      it "returns true" do
        game = Obscura::Game.new
        game.reputation = Obscura::Game::MAXIMUM_REPUTATION
        game.won?.should eq true
      end
    end
  end
end
