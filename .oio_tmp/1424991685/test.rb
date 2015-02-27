require_relative 'main'
describe "Deck" do
   before do
     @deck = Deck.new
   end
  it "is a deck" do
    expect(@deck.cards.length).to be 52
    expect(@deck.cards[0].class).to be Card
  end

end
describe "Game" do
  before do
    @players = Player.new('bob'), Player.new('mary'), Player.new('pat')

    @deck = Deck.new
    @new_game = Game.new(@players, 0, @deck.cards)
  end
  it "can play a game" do
    expect(@new_game).not_to be nil
  end

  describe "#deal_cards" do
    it "deals cards" do
      @new_game.deal_cards
    end

  end

  describe "#find_best_hand" do
    it "finds the best hand for a player's cards" do
      player1 = @new_game.players[0]
      @new_game.find_best_hand player1

    end
  end

  describe "@determine_winner" do
    it "does something" do
      p (@new_game.determine_winner(*@new_game.deal_cards)[0])
    end
  end

end