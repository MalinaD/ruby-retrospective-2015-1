class Card
SUITS = [:diamonds, :spades, :clubs, :hearts].freeze
RANKS = Hash[((2..10).to_a + [:jack, :queen, :king, :ace])
              .map.with_index.to_a]

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
include Enumerable
attr_reader :cards

  def initialize(deck)
    @deck = deck
  end

  def size()
    @deck.size
  end

  def each()
    return @deck.each unless block_given?
    @deck.each {|card| yield card}
  end

end

class WarHand < Hand
  def play_card
    @deck.draw_top_card
  end

  def allow_face_up?
    @deck.size <= 3
  end
end


class WarDeck < Deck
  HAND_SIZE = 26
  TOTAL_CARDS = 52

  def hand_size()
    HAND_SIZE
  end

  def hand_class()
    WarHand
  end

  def ranks()
    Card::RANKS
  end
end

class BeloteHand < Hand
  CARRE_COUNT = 4

  def highest_of_suit(suit)
    power = BeloteDeck::RANKS
    highest = Card.new(7, :spades)
    select { |c| c.suit == suit}
      .each { |c| highest = c if power[c.rank] > power[highest.rank] }

    highest
  end

  def belote?()
    kings = select { |card| card.rank == :king }
    kings.each do |king|
      match = select do |card|
        card.rank == :queen and card.suit == king.suit
      end

      return true if match.size != 0
    end

    false
  end

  def tierce?()
    cards_in_a_row?(3)
  end

  def quarte?()
    cards_in_a_row?(4)
  end

  def quint?()
    cards_in_a_row?(5)
  end

  def carre_of_jacks?()
    is_carre_of?(:jack)
  end

  def carre_of_nines?()
    is_carre_of?(9)
  end

  def carre_of_aces?()
    is_carre_of?(:ace)
  end

  private
  def cards_in_a_row?(amount)
    power = BeloteDeck::RANKS
    grouped = @deck.sort!{|a, b| power[a.rank] <=> power[b.rank]}.group_by {|card| card.suit}.values
    grouped.any? do |suited|
      next if suited.size < amount
      suited.each_cons(amount).any? do |con|
        are_following_numbers?(con)
      end
    end
  end

  def are_following_numbers?(numbers)
    numbers.each_cons(2).all? do |a, b|
      BeloteDeck::RANKS[b.rank] - BeloteDeck::RANKS[a.rank] == 1
    end
  end

  def is_carre_of?(rank)
    select { |card| card.rank == rank }.size == CARRE_COUNT
  end

end

class BeloteDeck < Deck
  RANKS = Hash[[7, 8, 9, :jack, :queen, :king, 10, :ace].map.with_index.to_a]
  HAND_SIZE = 8
  TOTAL_CARDS = 32

  def hand_size()
    HAND_SIZE
  end

  def hand_class()
    BeloteHand
  end

  def ranks()
    RANKS
  end
end

class SixtySixHand < Hand
  def twenty?(trump_suit)
    kings_and_queens?(trump_suit, -> (x, y) { x != y })
  end

  def forty?(trump_suit)
    kings_and_queens?(trump_suit, -> (x, y) { x == y })
  end

  private
  def kings_and_queens?(trump_suit, predicate)
    kings = select { |c| c.rank == :king and predicate.(c.suit, trump_suit) }

    kings.each do |king|
      return true if @cards.any? do |card|
        card.rank == :queen and card.suit == king.suit
      end
    end

    false
  end
end

class SixtySixDeck < Deck
  RANKS = Hash[[9, :jack, :queen, :king, 10, :ace].map.with_index.to_a]
  HAND_SIZE = 6
  TOTAL_CARDS = 24

  def hand_size()
    HAND_SIZE
  end

  def hand_class()
    SixtySixHand
  end

  def ranks()
    RANKS
  end
end

