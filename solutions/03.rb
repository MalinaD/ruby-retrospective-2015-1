class RationalSequence
include Enumerable

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

end