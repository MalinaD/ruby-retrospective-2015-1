class Card

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
  (self.class <=> other.class).zero?
end

def to_s
  "#{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
end

end

class Deck
include Enumerable

def initialize(cards = nil, ranks: nil, hand_type: nil, hand_size: 52)
  @hand_size = hand_size
  @hand_type = hand_type
  ranks ||= [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  @cards = cards || create_new_deck(ranks) 
  update_ranks(ranks)
end

def size
  @cards.count
end

def top_card
  @cards.first
end

def draw_top_card
  @cards.shift 
end

def draw_bottom_card
  @cards.pop 
end

def bottom_card
  @cards.last 
end

def shuffle
  @cards.shuffle!
end

def sort
  @cards.sort!
end

def each
  return @cards.each unless block_given?
  @cards.each {|card| yield card }
end

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

class Hand < Deck

  def initialize(deck, size)
    super deck.to_a.slice!(0, size)
    @deck = deck
    (0..size).each { deck.draw_top_card }
    self.sort
  end

  def ranks
    @deck.ranks
  end

end

class WarDeck < Deck

def deal
  Hand.new(self, 26)
end

class Hand < Deck::Hand
  def play_card
    draw_top_card
  end

  def allow_face_up?
    size <= 3
  end
end

end

