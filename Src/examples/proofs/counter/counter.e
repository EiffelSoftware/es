indexing
	description: "Summary description for {COUNTER}."
	date: "$Date$"
	revision: "$Revision$"

class
	COUNTER

create
	make_zero

feature {NONE} -- Initialization

	make_zero
			-- Initialize empty counter.
		do
			value := 0
		ensure
			value_is_zero: value = 0
		end

feature -- Access

	value: INTEGER
			-- Value of counter

feature -- Basic operations

	increment
			-- Increment counter by 1.
		do
			value := value + 1
		ensure
			value_incremented: value = old value + 1
		end

	decrement
			-- Decrement counter by 1.
		do
			value := value - 1
		ensure
			value_decremented: value = old value - 1
		end

	add (other: !COUNTER)
			-- Add value of `other' to counter.
		do
			value := value + other.value
		ensure
			added: value = old (value + other.value)
--			frame: other.value = old (other.value)
		end

end
