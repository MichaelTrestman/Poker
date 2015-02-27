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

    it "returns the winner's index" do

      @new_game.play
      # @new_game.determine_winner(*@new_game.deal_cards)


    end
    it "detects flushes" do
      @new_game.current_player_cards = [
        Card.new('heart', 2),
        Card.new('spade', 5),
        Card.new('clover', 1),
        Card.new('horshoe', 4),
        Card.new('batman', 9),
        Card.new('hash-rocket', 12),
        Card.new('something else', 10)
      ]
      expect(@new_game.find_flush).to be false

      @new_game.current_player_cards = [
        Card.new('heart', 2),
        Card.new('heart', 5),
        Card.new('heart', 1),
        Card.new('heart', 4),
        Card.new('heart', 9),
        Card.new('heart', 12),
        Card.new('heart', 10)
      ]
      expect(@new_game.find_flush).not_to be false
    end
    it "detects full houses" do
      @new_game.current_player_cards = [
        Card.new('heart', 2),
        Card.new('spade', 5),
        Card.new('clover', 1),
        Card.new('horshoe', 4),
        Card.new('batman', 9),
        Card.new('hash-rocket', 12),
        Card.new('something else', 10)
      ]
      expect(@new_game.find_full_house).to be false

      @new_game.current_player_cards = [
        Card.new('heart', 2),
        Card.new('spade', 2),
        Card.new('clover', 2),
        Card.new('horshoe', 4),
        Card.new('batman', 4),
        Card.new('hash-rocket', 12),
        Card.new('something else', 10)
      ]
      expect(@new_game.find_full_house).not_to be false
    end
  end
  it "detects straight flushes" do
    @new_game.current_player_cards = [
      Card.new('heart', 2),
      Card.new('spade', 5),
      Card.new('clover', 1),
      Card.new('horshoe', 4),
      Card.new('batman', 9),
      Card.new('hash-rocket', 12),
      Card.new('something else', 10)
    ]
    expect(@new_game.find_straight_flush).to be false

    @new_game.current_player_cards = [
      Card.new('heart', 2),
      Card.new('heart', 3),
      Card.new('heart', 4),
      Card.new('heart', 5),
      Card.new('heart', 6),
      Card.new('heart', 7)

    ]
    expect(@new_game.find_straight_flush).not_to be false
  end



end