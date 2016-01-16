module DrunkenMathematician
module_function

class RationalSequence
include Enumerable

end

class PrimeSequence
include Enumerable
def is_prime?(number)
if number<5
if number==2 || number==3
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

def next_prime(max)
arr = []
n = 2
(max * 2).times do
if is_prime?(n)
arr << n
end
n += 1
end
print arr
end

end



class FibonacciSequence
include Enumerable

def fibonacci(n)
n.times.each_with_object([0,1]) { |number, obj| obj << obj[-2] + obj[-1] }
end

def fibonacci_second(n, first: 0, second: 1)
number = second
number_second = second
print first.to_s + ", "
while number < n
yield number
number, number_second = number_second, number_second + number
end

end
fibonacci_second(7) { |m| print m, ", " }
end

def aimless(n)
array = next_prime(n)
new_array = []
if n%2 == 0
array.to_a.each do |m|
new_array << Rational(m, m+1)
m += 2
end
print new_array

else
array.push(1)
array.to_a.each do |m|
new_array.push(Rational(m, m+1))
m += 2
end
print new_array
end
end
end