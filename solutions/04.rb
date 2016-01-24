class Card
SUITS = [:diamonds, :spades, :clubs, :hearts].freeze
RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

attr_reader :rank, :suit

def initialize(rank,suit)
  @rank = rank
  @suit = suit
end

def <=>(another_card)
  @rank <=> another_card.rank
  @suit <=> another_card.suit
end

def ==(other)
  @rank == other.rank && @suit == other.suit
end

def to_s
  "#{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
end

end

class Deck
include Enumerable

def initialize(cards = nil)
  @cards = cards || create_new_deck()
end

def size
  @cards.size
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
  @cards.sort!.reverse!
  self
end

def each
  return @cards.each unless block_given?
  @cards.each {|card| yield card }
end

def to_s
  @cards.map(&:to_s).join("\n")
end

def deal()
  hand = []
  hand_size().times { hand << draw_top_card unless size == 0 }

  hand_class.new(hand)
end

def ranks()
  Card::RANKS
end

private

def create_new_deck()
  ranks().keys.product(Card::SUITS).map{|r, s| Card.new(r, s)}
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
    @deck.draw_top_card
  end

  def allow_face_up?
    @deck.size <= 3
  end
end

end

class SixtySixDeck < Deck
  def ranks
    [9, :jack, :queen, :king, 10, :ace]
  end

  def deal
    Hand.new(self, 6)
  end

  class Hand < Deck::Hand
    def king_and_queen
      sort
      @cards.each_cons(2).find_all do |pair|
        pair.first.suit == pair.last.suit &&
          pair.first.rank == :king && pair.last.rank == :queen
      end
    end

    def twenty?(trump_suit)
      king_and_queen.any?{ |pair| !pair.nil? && pair.first.suit != trump_suit }
    end

    def forty?(trump_suit)
      king_and_queen.any?{ |pair| !pair.nil? && pair.first.suit == trump_suit }
    end
  end
end

