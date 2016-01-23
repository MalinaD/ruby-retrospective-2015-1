class RationalSequence
include Enumerable

def initialize(count)
	@count = count
end

def get_raw(position)
	current_position , key = position , 1
	while current_position >= key
		current_position -= key
		key += 1
	end
    if key.even?
    	[key - current_position, current_position + 1]
    else
    	[current_position + 1, key - current_position]
    end
end

def each
	current, current_count = 0, 0
	while current_count < @count
		numerator, denominator = get_raw current
		if numerator.gcd(denominator) == 1
			yield Rational(numerator, denominator)
			current_count += 1
		end
		current += 1
	end
end
end

class PrimeSequence
include Enumerable

def initialize(count)
	@count = count
end

def is_prime?(number)
	2.upto(Math.sqrt(number).to_i) do |divisor|
		return false if number % divisor == 0
	end
	true
end

def each
	number, counter = 2, 0

	while counter < @count
		if is_prime?(number)
			yield number
			counter += 1
		end
		number += 1
	end
end

end

class FibonacciSequence
include Enumerable

def initialize(count, first_two_members = {first: 1, second: 1})
	@count = count
	@first = first_two_members[:first]
	@second = first_two_members[:second]
end

def each
	previous, current, counter = @first, @second, 0

	@count.times do
		yield previous
		previous, current = current, current + previous
	end
end
end

module DrunkenMathematician
module_function

def aimless(count)
	sequence = PrimeSequence.new(count)
	new_sequence = Array.new
    return 0 if count == 0
	new_sequence = sequence.each_slice(2).map do |pair|
		pair.length == 2? Rational(pair[0], pair[1]) : Rational(pair[0])
	end

	new_sequence.reduce(0, :+)
end

def meaningless(count)
	groups = RationalSequence.new(count).partition do |rational|
		is_prime?(rational.numerator) or is_prime?(rational.denominator)
	end

	groups[0].reduce(1, :*) / groups[1].reduce(1, :*)
end

def worthless(n)
	limit = FibonacciSequence.new(n).to_a.fetch(-1, 0)
	rationals = RationalSequence.new(Float::INFINITY).lazy
	sum = 0
	rationals.take_while do |rational|
		sum += rational
		sum <= limit
	end.force
end

def is_prime?(number)
	2.upto(Math.sqrt(number).to_i) do |divisor|
		return false if number % divisor == 0
	end
	true
end

end