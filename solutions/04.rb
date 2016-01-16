class Card
include Comparable
  RANKS = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  SUITS = %w(Spade Heart Club Diamond)
  attr_accessor :rank
  attr_accessor :suit

def initialize(id,rank,suit)
  self.rank = RANKS[id % 13]
  self.suit = SUITS[id % 4]
end

def rank
@rank
end

def rank=(value)
  @rank = value
end

def suit
@suit
end

def suit=(value)
  @suit = value
end
 
def to_s
@rank + @suit
end

 def <=>(another_card)
        ##
        # We are only comparing cards based on their rank, so we can 
        # just return the result of the same operator on the cards'
        # rank attribute
        
        @rank <=> another_card.rank
        @suit <=> another_card.suit
    end

end

class Deck
  attr_accessor :cards

  def initialize
    # shuffle array and init each Card
    self.cards = (0..51).to_a.shuffle.collect { |id| Card.new(id) }
  end

def size
self.cards.length
end

def draw_top_card
self.cards = (0..51).to_a.shift
end

def draw_bottom_card
self.cards = (0..51).to_a.pop
end

def top_card
self.cards = (0..51).to_a.first
end

def bottom_card
self.cards = (0..51).to_a.last
end

def shuffle
self.cards = (0..51).to_a.shuffle
end

def sort
self.cards = (0..51).to_a.sort
end

def to_s
@cards
end

end

test

d = Deck.new
d.cards.each do |card|
  puts "#{card.rank} #{card.suit}"
end



class WarDeck

def initialize(player_one, player_two)
@player_one = player_one
@player_two = player_two
end

def play_game
@deck = Deck.new

1.upto(5) do |number|
@player_one.hand << @deck.
end

end