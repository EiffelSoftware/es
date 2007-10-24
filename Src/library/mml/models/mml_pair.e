indexing
	description: "Mathematical objects containing two possibly equal elements in a specific order"
	version: "$Id$"
	author: "Tobias Widmer and Bernd Schoeller"
	copyright: "see License.txt"

deferred class
	MML_PAIR [G, H]

inherit
	MML_ANY

feature {NONE} -- Initialization

	make_from (one: G; two: H) is
			-- Create a new pair with `one' and `two'.
		deferred
		ensure
			first_element_set : equal_value(first,one)
			second_element_set : equal_value(second,two)
		end

feature -- Access

	first: G is
			-- The first element of `current'.
		deferred
		end

	second: H is
			-- The second element of `current'.
		deferred
		end

feature -- Status Report

	is_identity : BOOLEAN is
			-- Does `current' only contain identical elements?
		deferred
		ensure
			definition_of_identity : equal_value (first, second)
		end

feature -- Inversion

	inversed : MML_PAIR[H, G] is
			-- The inverse pair of `current'.
		deferred
		ensure
			definition_of_inversed : equal_value (Result.first, second) and equal_value (Result.second, first)
		end

invariant
	definition_of_inversion : equal_value (Current, inversed.inversed)
	definition_of_identity : is_identity implies equal_value (first, second)
end -- class MML_PAIR
