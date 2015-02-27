require_relative 'main'

describe "Game" do
  before do
    @new_game = Game.new(nil, nil, nil)

  end
  it "can play a game" do
    expect(@new_game).not_to be nil
  end
  describe "#deal_cards" do
    it "deals cards" do
      p @new_game.deal_cards
    end

  end
  describe "@determine_winner" do
    it "does something" do

    end

  end

end