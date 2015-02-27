#!/usr/bin/env ruby

Card = Struct.new(:suite, :number) do
  def to_s
    "{#{suite}, #{number}}"
  end
end

Player = Struct.new(:name) do
  def to_s
    name
  end
end

class Game
  attr_reader :players, :dealer_index, :deck

  def initialize(players, dealer_index, deck)
    @players = players
    @dealer_index = dealer_index
    @deck = deck
  end

  def play
    all_hole_cards, flop, turn, river = deal_cards
    all_hole_cards.each_with_index { |hole_cards, index| puts "#{index}: #{hole_cards[0]}, #{hole_cards[1]}" }
    puts (flop + [turn] + [river]).join " "

    winner_index = determine_winner(all_hole_cards, flop, turn, river)
    puts "winner is #{players[winner_index]}"
    return players[winner_index]
  end

  def deal_cards
    num_players = players.size
    all_hole_cards = (1..num_players).map { |i| [deck.shift] }
    (1..num_players).each { |i| all_hole_cards[i - 1] << deck.shift }
    deck.shift(2) # burn
    flop = deck.shift(3)
    deck.shift # burn
    turn = deck.shift
    deck.shift # burn
    river = deck.shift

    return all_hole_cards, flop, turn, river
  end

  def determine_winner(all_hole_cards, flop, turn, river)
    0
  end
end

if __FILE__ == $0
  num_players = 4
  num_games = 5
  players = (1..num_players).map { |i| Player.new("player-#{i}") }
  dealer_index = 0

  num_games.times do |i|
    deck = ["spade", "heart", "diamond", "club"].flat_map do |suite|
      (1..13).map { |number| Card.new(suite, number) }
    end.shuffle
    game = Game.new(players, dealer_index, deck)
    game.play()
    dealer_index += 1
  end
end