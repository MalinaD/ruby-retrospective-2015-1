class Card
#RANKS = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
#SUITS = %w(Spade Heart Club Diamond)

attr_reader :rank, :suit
attr_accessor :position

def initialize(rank,suit, position = 0)
  @rank = rank
  @suit = suit
  @position = position
end
 
def <=>(another_card)        
  @rank <=> another_card.rank
  @suit <=> another_card.suit
end

def ==(other)
  (self <=> other).zero?
end

def to_s
  "#{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
end
end

class Deck
include Enumerable
#attr_accessor :cards

def initialize(cards = nil, ranks: nil, hand_type: nil, hand_size: 52)
  @hand_size = hand_size
  @hand_type = hand_type
  ranks ||= [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  self.cards = cards || create_new_deck(ranks) 
  #(0..51).to_a.shuffle.collect { |id| Card.new(id) }
  update_ranks(ranks)
end

def size
  @cards.count
end

def top_card
  @cards.first
end

def draw_top_card
  @cards.shift #(0..51).to_a.shift
end

#def draw_bottom_card
  #@cards.pop #(0..51).to_a.pop
#end

def bottom_card
  @cards.last #(0..51).to_a.last
end

def shuffle
  @cards.shuffle! #(0..51).to_a.shuffle
end

def sort
  @cards.sort! #(0..51).to_a.sort
end

def each
  @cards.each {|card| yield card }

def to_s
  @cards.each(&:to_s)
end

private 
def create_new_deck(ranks)
    suits = %i(spades hearts diamonds clubs)

    suits.product(ranks.to_a).shuffle.map do |product|
      suit, rank = product

      Card.new(rank, suit)
    end
end

  def update_ranks(ranks)
    @cards.each do |card|
      card.position = ranks.index(card.rank) + 1
    end
  end
end

#class WarDeck

#def initialize(player_one, player_two)
#  @player_one = player_one
#  @player_two = player_two
#end

#def play_game
 # @deck = Deck.new

 # 1.upto(5) do |number|
 # @player_one.hand << @deck.
  #end
#end

