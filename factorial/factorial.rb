def factorial x
	raise "cannot compute factorial of a negative number" if x < 0
	x == 0 ? 1 : (1..x).reduce(:*)
end
