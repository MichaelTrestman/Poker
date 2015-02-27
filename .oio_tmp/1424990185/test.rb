require_relative 'main'

describe "Game" do
  before do
    @new_game = Game.new(Player.new('bob'), Player.new('mary'), Player.new('pat'))
    @deck = Deck.new
  end
  it "can play a game" do
    expect(@new_game).not_to be nil
  end
  describe "#deal_cards" do
    it "deals cards" do
      # p @new_game.deal_cards
    end

  end
  describe "Deck" do
    it "is a deck" do
      p @deck
    end

  end
  describe "@determine_winner" do
    it "does something" do

    end

  end

end