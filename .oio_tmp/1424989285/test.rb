require_relative 'main'

describe "Game" do
  it "can play a game" do
    new_game = Game.new(nil, nil, nil)
    expect(new_game).not_to be nil
  end
  describe "@determine_winner" do
    it "does something" do

    end

  end

end