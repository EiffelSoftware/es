note
	description: "Summary description for {TEST5A}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_INV_A

create
	make

feature {NONE} -- Initialization

	make (a_value: DOUBLE)
		do
			value := a_value
			establish_invariant
		ensure
			value_set: value = a_value or value = -a_value or value = 10
		end

feature -- Access

	invariant_from_a_count: INTEGER
	invariant_from_b_count: INTEGER

	value: DOUBLE

	self: attached like Current
		do
			Result := Current
		end

feature -- Basic Operation

	do_something_on_value
		do
			invert_value
			establish_invariant
		end

feature {NONE} -- Implementation

	invert_value
		do
			value := - value
		end

	establish_invariant
		do
			value := value.abs
			Current.qualified_call
		end

	invariant_from_a: BOOLEAN
		do
			invariant_from_a_count := invariant_from_a_count + 1
			Result := value > 0
		end

feature {TEST_INV_A}

	qualified_call
		do
			check value > 0 end
			-- Nothing
		end

invariant
	inv: invariant_from_a

end
