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
	if number < 5
		if number == 2 || number == 3
			return true
		else
			return false
		end
	end

	2.upto(Math.sqrt(number).to_i) do |x|
		return false if number % x == 0
	end
	true
end

def each
	number = 2
	counter = 0

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
	previous = @first
	current = @second
	counter = 0

	while counter < @count
		yield previous
		previous, current = current, current + previous
		counter += 1
	end
end
end

module DrunkenMathematician
module_function

def aimless(n)
	sequence = PrimeSequence.new(n)
	new_sequence = []

	sequence.each_slice(2) do |pair|
		pair << 1 if pair.length < 2
		new_sequence << Rational(pair[0], pair[1])
	end

	new_sequence.reduce(0, :+)
end

def meaningless(n)
	groups = RationalSequence.new(n).partition do |rational|
		is_prime?(rational.numerator) or is_prime?(rational.denominator)
	end

	groups[0].reduce(1, :*) / groups[1].reduce(1, :*)
end

def worthless(n)
end

def is_prime?(number)
	if number < 5
		if number == 2 || number == 3
			return true
		else
			return false
		end
	end

	2.upto(Math.sqrt(number).to_i) do |x|
		return false if number % x == 0
	end
	true
end

end