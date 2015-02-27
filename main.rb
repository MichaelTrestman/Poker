#!/usr/bin/env ruby

Card = Struct.new(:suite, :number) do
  def to_s
    "{#{suite}, #{number}}"
  end
  def num
    number
  end
  def suit
    suite
  end
end

Player = Struct.new(:name) do
  def to_s
    name
  end
end

class Game
  attr_accessor :players, :dealer_index, :deck, :current_player_cards

  def initialize(players, dealer_index, deck)
    @shared_cards
    @players = players
    @dealer_index = dealer_index
    @deck = deck
    deal_cards
  end

  def play
    all_hole_cards, flop, turn, river = deal_cards
    all_hole_cards.each_with_index { |hole_cards, index| puts "player#{@players[index].name}: #{hole_cards[0]}, #{hole_cards[1]}" }
    puts "shared cards:"

    puts (flop + [turn] + [river]).join " "
    puts
    puts
    puts
    winner_indices = determine_winner(all_hole_cards, flop, turn, river)
    puts "$$$$$$$$$"
    p winner_indices
    winner_indices.each { |w_i|

      puts "winner is #{players[w_i]} with a #{@best_hands_of_each_player[w_i]}"
    }
    return winner_indices

  end

  def deal_cards
    num_players = players.size
    all_hole_cards = (1..num_players).map { |i| [deck.shift] }
    @all_hole_cards = all_hole_cards
    (1..num_players).each { |i| all_hole_cards[i - 1] << deck.shift }
    deck.shift(2) # burn
    flop = deck.shift(3)

    deck.shift # burn
    turn = deck.shift

    deck.shift # burn
    river = deck.shift

    @shared_cards = flop
    @shared_cards += [turn,  river]
    return [
      all_hole_cards,
      flop,
      turn,
      river
    ]
  end


  def determine_winner(all_hole_cards, flop, turn, river)
    @best_hands_of_each_player = @players.map { |player| find_best_hand player }

    winners = []
    counter = 0
    until winners.length > 0 or counter > 1000000

      counter += 1

      ['straight flush', 'four of a kind', 'full house', 'flush', 'straight', 'three of a kind',"two pairs", "pair","high card"].each do |hand|

        if winners.length == 0

          players.each do |player|
            winners << player if hand == @best_hands_of_each_player[@players.index player][0]

          end
        end
      end
    end

    if winners.length > 1
      winners = break_tie winners
    end
    p 'winners!!!!!!!!!!'
    p winners
    return winners.map { |e|  @players.index e }

  end
  def break_tie winners
    high_cards = {}

    winners = winners.sort_by do |player|

      best_hand = @best_hands_of_each_player[@players.index player]
      # puts
      # puts "player | best hand"
      # p player.name
      # p best_hand
      # puts
      high_card = best_hand[1]
        .map{|card| card.num }
        .sort_by { |card| card }
        .last

      high_cards[player] = high_card
      high_card
    end

    # puts "best hands of each player:"
    # p best_hands_of_each_player

    # highest_card_of_any_player =
    # @best_hands_of_each_player.map do |hand|
    #     hand[1].sort_by{|card| card.num}.last
    # end.sort_by{|card| card.num}.last

    highest_card_of_any_winner =
    winners.map do |player|
      @best_hands_of_each_player[@players.index player]
    end.map do |hand|
        hand[1].sort_by{|card| card.num}.last
    end.sort_by{|card| card.num}.last

    # p "high card!!!"
    # p highest_card_of_any_player

    winners = winners.select do |player|
      # p "!!!!!!!!!!!!!!"
      # p 'winner selection'
      # p player
      # p highest_card_of_any_winner

      # p high_cards[player]
      high_cards[player] == highest_card_of_any_winner.num
    end


  end

  def find_best_hand player
    @current_player_cards = @all_hole_cards[@players.index player] + @shared_cards
    # these must all be implemented!
    # return ['straight flush', find_straight_flush] if find_straight_flush
    # return ['four of a kind', find_four_of_a_kind] if find_four_of_a_kind
    # return ['full house', find_full_house] if find_full_house
    return ['flush', find_flush] if find_flush
    return ['straight', find_straight] if find_straight
    return ['three of a kind', find_three_of_a_kind] if find_three_of_a_kind
    return ["two pairs", find_two_pairs] if find_two_pairs
    return ["pair", find_pair] if find_pair
    return ["high card", find_highest_card]
  end

  def find_flush
    ["spade", "heart", "diamond", "club"].each do |suit|
      cards_in_suit = @current_player_cards.select{|card| card.suite == suit}
      return cards_in_suit if cards_in_suit.length > 5
    end
    false
  end

  def find_straight
    straight = false
    cards = @current_player_cards.sort_by{|card| card.num}.reverse
    cards.each do |card|
      maybe_straight = true
      num = card.num
      possible_straight = [card]

      while maybe_straight
        num -= 1
        next_in_straight = cards.select do |card|
          card.num == num
        end
        if next_in_straight.length > 0
          possible_straight << next_in_straight[0]
        else
          maybe_straight = false
        end
      end
      return possible_straight if possible_straight.length >= 5
      return false
    end
  end

  def find_three_of_a_kind
    three_of_a_kind = false
    nums = *(1..13)
    nums.each do |num|
      cards_with_num = []
      @current_player_cards.each do |card|
        cards_with_num << card if card.num == num
      end
      three_of_a_kind = cards_with_num if cards_with_num.length > 2
    end
      three_of_a_kind
  end
  def find_two_pairs
    two_pairs = false
    pairs = []
    nums = *(1..13)
    nums.each do |num|
      cards_with_num = []
      @current_player_cards.each do |card|
        cards_with_num << card if card.num == num
      end
      pairs << cards_with_num if cards_with_num.length > 1
    end
    two_pairs = pairs.flatten if pairs.length > 1
    two_pairs
  end
  def find_pair
    pair = false
    nums =  *(1..13)
    nums.each do |num|
      cards_with_num = []
      @current_player_cards.each { |card| cards_with_num << card if card.num == num  }
      pair = cards_with_num if cards_with_num.length > 1
    end
    pair
  end
  def find_highest_card

    nums =  *(1..13)
    nums.reverse.each do |val|
      @current_player_cards.each do |card|
        return [card] if card.num == val
      end
    end
    raise 'couldnt find high card :('
    return false
  end

end

class Deck

  def initialize
    @deck =
      ["spade", "heart", "diamond", "club"].flat_map do |suite|
        (1..13).map { |number| Card.new(suite, number) }
      end.shuffle
  end

  def cards
    return @deck
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